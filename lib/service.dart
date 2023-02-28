import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_notification/local_notification.dart';

class FirebaseNotificationService {
  late final FirebaseMessaging messaging;

  void settingNotification() async {
    await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  void connectionNotification() async {
    await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;

    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    settingNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('gelen bildirim basligi : ${message.notification?.title}');
      print('message title : ${message.notification?.body}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        LocalNotificationService.createNotification(message);
      }
    });

    messaging
        .getToken()
        .then((value) => log('Token : $value', name: 'FCm token'));
  }

  static Future<void> backgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    print('handling a backgroung message ${message.messageId}');
  }

  void showNotification() {}
}
