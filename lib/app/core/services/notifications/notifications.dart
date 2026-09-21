part of 'firebase_cloud_messaging.dart';

Future<void> _createNotification({
  required String title,
  required String body,
  String? bigPicture,
  int? id,
  Map<String, String?>? payload,
  bool? locked,
}) async {
  final math.Random random = math.Random();
  final int randomNumber = random.nextInt(100);
  await awesomeNotifications.createNotification(
    content: NotificationContent(
      id: id ?? randomNumber,
      channelKey: 'actions_channel',
      title: title,
      locked: locked ?? false,
      body: body,
      bigPicture: bigPicture,
      payload: payload,
      groupKey: "actions_channel_group",
      displayOnBackground: true,
      displayOnForeground: true,
      wakeUpScreen: true,
      notificationLayout:
          bigPicture != null
              ? NotificationLayout.BigPicture
              : NotificationLayout.BigText,
    ),
  );
}
