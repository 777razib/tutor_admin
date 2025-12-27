// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationServices {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void requestNotificationPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print("User granted permission");
//       }
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print("User granted provisional permission");
//       }
//     } else {
//       if (kDebugMode) {
//         print("User denied permission");
//       }
//     }
//   }

//   void initLocalNotifications(
//       BuildContext context, RemoteMessage message) async {
//     var androidInitSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     var initializationSettings = InitializationSettings(
//       android: androidInitSettings,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         if (kDebugMode) {
//           print("User tapped on notification");
//         }
//       },
//     );

//     // Create Notification Channel
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'nathancloud_notification_channel',
//       'NathanCloud Notifications',
//       description: 'NathanCloud channel description',
//       importance: Importance.high,
//     );

//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     FirebaseMessaging.onMessage.listen((message) {
//       showNotification(message);
//     });
//   }

//   void firebaseInit() {
//     FirebaseMessaging.onMessage.listen((message) {
//       if (message.notification != null) {
//         if (kDebugMode) {
//           print("Foreground Notification: ${message.notification!.title}");
//         }
//         showNotification(message);
//       }
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       if (kDebugMode) {
//         print("Notification clicked! Open app");
//       }
//     });

//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) {
//         if (kDebugMode) {
//           print(
//               "App launched from notification: ${message.notification!.title}");
//         }
//       }
//     });
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'nathancloud_notification_channel',
//       'NathanCloud Notifications',
//       channelDescription: 'NathanCloud channel description',
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: 'ticker',
//       icon: '@mipmap/ic_launcher', // Ensure the small icon is set
//     );

//     NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title ?? "No Title",
//       message.notification?.body ?? "No Body",
//       notificationDetails,
//     );
//   }

//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }

//   void isTokenRefresh() async {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//     });
//   }
// }
