part of 'firebase_cloud_messaging.dart';

List<NotificationChannel> channels = [
  NotificationChannel(
    channelGroupKey: 'actions_channel_group',
    channelKey: 'actions_channel',
    channelName: 'Account Actions',
    channelDescription:
        'This channel is to receive notifications of activation of codes',
    defaultColor: AppColors.primary,
    importance: NotificationImportance.Max,
    defaultRingtoneType: DefaultRingtoneType.Notification,
    playSound: true,
    channelShowBadge: false,
    defaultPrivacy: NotificationPrivacy.Public,
    onlyAlertOnce: false,
    enableVibration: true,
    enableLights: true,
  ),
];
List<NotificationChannelGroup> groups = [
  NotificationChannelGroup(
    channelGroupKey: 'actions_channel_group',
    channelGroupName: 'actions',
  ),
];
