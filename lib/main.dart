import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iamsmart/model/user_profile.dart';
import 'package:iamsmart/service/db_service.dart';
import 'package:iamsmart/util/preference_key.dart';

import 'package:iamsmart/util/router.dart';
import 'package:iamsmart/util/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'service/auth_provider.dart';

late SharedPreferences prefs;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupFirebaseMessaging();

  if (prefs.containsKey(PreferenceKey.user)) {
    UserProfile userProfile =
        UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
    await DBService.instance.updateLastLoginTime(userProfile.id!);
    UserProfile updatedProfile =
        await DBService.instance.getUserById(userProfile.id!);
    prefs.setString(PreferenceKey.user, updatedProfile.toJson());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => AuthProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'IamSmart',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: globalTheme(context),
      ),
    );
  }
}

Future<void> setupFirebaseMessaging() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  messaging.getToken().then((value) {
    prefs.setString(PreferenceKey.fcmToken, value ?? '');
  });

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      publishNotification(
          message.notification?.title ?? '', message.notification?.body ?? '');
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  publishNotification(
      message.notification?.title ?? '', message.notification?.body ?? '');
}

Future<void> publishNotification(String title, String body) async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel_ID_iamsmart', 'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('ringtone'),
      showProgress: true,
      priority: Priority.high,
      ticker: 'test ticker');

  var iOSChannelSpecifics = const DarwinNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(0, title, body, platformChannelSpecifics, payload: 'test');
}
