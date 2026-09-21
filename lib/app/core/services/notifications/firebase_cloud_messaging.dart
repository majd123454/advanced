import 'dart:async';
import 'dart:math' as math;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:just_audio/just_audio.dart';
import 'package:swb_advance/app/core/helper/constants/enum.dart';
import 'package:swb_advance/app/core/helper/logger.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';
import 'package:vibration/vibration.dart';

part 'channels.dart';
part 'notifications.dart';

AwesomeNotifications awesomeNotifications = AwesomeNotifications();

AppMode appMode = AppMode.development;

class NotificationService {
  NotificationService._internal();
  static NotificationService instance = NotificationService._internal();

  Future<String?> getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      return 'unknown';
    }
  }

  Future<void> deleteToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}
  }

  Future<bool> isSupported() async {
    return await FirebaseMessaging.instance.isSupported();
  }

  Future<void> stopNotifications() async {
    try {
      logger('stopNotifications');

      // حذف الـ FCM token
      await deleteToken();

      // إيقاف الـ listeners
      // (إعادة تعين البث الفارغ يقطعه)
      FirebaseMessaging.onMessage.drain();

      // حذف جميع الاشعارات المعروضة
      await awesomeNotifications.cancelAll();

      logger('Notifications stopped successfully');
    } catch (e) {
      logger(
        'Error stopping notifications: $e',
        name: 'stopNotifications error',
      );
    }
  }

  Future<void> requestPermission() async {
    try {
      await FirebaseMessaging.instance.requestPermission();

      final bool result = await awesomeNotifications
          .requestPermissionToSendNotifications(
            permissions: [
              NotificationPermission.Alert,
              NotificationPermission.Sound,
              NotificationPermission.Badge,
              NotificationPermission.Vibration,
              NotificationPermission.Light,
            ],
          );

      logger(result.toString(), name: 'requestPermissionToSendNotifications');
    } catch (e) {
      logger(e.toString(), name: 'requestPermissionToSendNotifications error');
    }
  }

  Future<void> initializeNotifications() async {
    try {
      await requestPermission();
      await initializeAwesomeNotifications();
      await _onMessage();
    } catch (e) {
      logger(e.toString());
    }
  }

  Future<void> initializeAwesomeNotifications() async {
    logger('initializeAwesomeNotifications');

    await awesomeNotifications.initialize(
      null,
      channels,
      channelGroups: groups,
      debug: appMode != AppMode.release,
    );

    awesomeNotifications.setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );

    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      logger(
        (initialMessage.notification?.title).toString(),
        name: "Initial Message title",
      );

      logger(
        (initialMessage.notification?.body).toString(),
        name: "Initial Message body",
      );

      logger(initialMessage.data.toString(), name: "Initial Message data");

      handleNotificationTap(initialMessage.data);
    }
  }

  Future<void> cancelNotifcation(int id) async {
    await awesomeNotifications.cancel(id);
  }

  Future<void> _onMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      logger((message.notification?.title).toString(), name: "onMessage title");
      logger((message.notification?.body).toString(), name: "onMessage body");
      logger(message.data.toString(), name: "onMessage data");

      try {
        final AudioPlayer player = AudioPlayer();

        if (message.notification != null ||
            (message.data["title"] != null && message.data["body"] != null)) {
          String title =
              message.notification?.title ??
              message.data["title"] ??
              "Notification";
          String body =
              message.notification?.body ??
              message.data["body"] ??
              "You have a new notification";

          _createNotification(
            title: title,
            body: body,
            bigPicture: message.data["image_url"] ?? message.data["image"],
            payload: convertMap(message.data),
          );

          if (message.data.toString().contains("arriveToMeetingPoint")) {
            player.setAsset('assets/audios/car-horn-taxi.mp3').then((value) {
              player.play();
            });
          }

          Vibration.vibrate(duration: 100);
        }

        dataNotificationHandler(message.data);
      } catch (e) {
        logger(e.toString(), name: "onMessage error");
      }
    });
  }
}

@pragma("vm:entry-point")
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  if (receivedAction.payload == null) return;

  handleNotificationTap(receivedAction.payload!);
}

@pragma("vm:entry-point")
Future<void> handleNotificationTap(
  Map<String, dynamic> payload, [
  int counter = 0,
]) async {}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  try {
    logger(
      (message.notification?.title).toString(),
      name: "firebaseMessagingBackgroundHandler title",
    );

    logger(
      (message.notification?.body).toString(),
      name: "firebaseMessagingBackgroundHandler body",
    );

    logger(
      message.data.toString(),
      name: "firebaseMessagingBackgroundHandler data",
    );

    if (message.notification == null &&
        (message.data["title"] != null && message.data["body"] != null)) {
      await initializeAwesomeNotificationsForBackground();

      _createNotification(
        title: message.data["title"],
        body: message.data["body"],
        bigPicture: message.data["image_url"] ?? message.data["image"],
        payload: convertMap(message.data),
      );
    }

    dataNotificationHandler(message.data);
  } catch (e) {
    logger(e.toString(), name: "firebaseMessagingBackgroundHandler error");
  }
}

Map<String, String?> convertMap(Map<String, dynamic> originalMap) {
  final newMap = <String, String?>{};

  originalMap.forEach((key, value) {
    if (value is String) {
      newMap[key] = value;
    } else {
      newMap[key] = null;
    }
  });

  return newMap;
}

@pragma('vm:entry-point')
Future<void> initializeAwesomeNotificationsForBackground() async {
  logger('initializeAwesomeNotificationsForBackground');

  await awesomeNotifications.initialize(
    null,
    channels,
    channelGroups: groups,
    debug: appMode != AppMode.release,
  );
}

@pragma('vm:entry-point')
Future<void> dataNotificationHandler(Map<String, dynamic> data) async {}
