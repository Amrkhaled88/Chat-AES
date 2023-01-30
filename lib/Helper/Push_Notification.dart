import 'dart:convert';

import "package:firebase_core/firebase_core.dart";
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterappaes/view/Chats/Users.dart';
import 'package:http/http.dart'as http;
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    "High Importance Notifcations",
    "This channel is used important notification");

final FlutterLocalNotificationsPlugin flutterLocalNotificationplugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message : ${message.messageId}");
  print(message.data);
  flutterLocalNotificationplugin.show(
      message.hashCode,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
          android: AndroidNotificationDetails(
              channel.id, channel.name, channel.description,
            icon: 'asset/images/Logo/logo.png'
             )));
}
class FirebaseNotifcation {
  initialize(context) async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationplugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var intializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: intializationSettingsAndroid);

    flutterLocalNotificationplugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationplugin.show(
            notification.hashCode,
            message.data['title'],
            message.data['body'],
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    icon: android.smallIcon))
        );
      }
      print('${message.data['title']}');

    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.push(context,MaterialPageRoute(builder: (context)=>UsersShow()));
    });
  }


  Future<String?> getToken() async {
      return await FirebaseMessaging.instance.getToken();
  }
  Future<void> sendPushMessage(_token,senderName,_message) async {
    var serverKey='AAAACRB_LQM:APA91bELCCRnsPhPWEy4aXRIn9LfrbpxQZPIggmKHTO8eG2eN3eXthwuU5OsW77VcuRb7R1g1jwsjkMIwMKlMzY7KhVUU8-oA15KuKwRbzjVVPiy_uwNsEIDj4-7Y51dlMIKmXdsAais';
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':'key=$serverKey'
        },
        body: jsonEncode(
            {
              'to': '${_token.toString()}',
              'android': {
                'priority': "high",
              },
              'data': {
                'title': senderName.toString(),
                'body': _message.toString(),
                'icon': 'asset/images/Logo/logo.png',
                'click_action': 'FLUTTER_NOTIFICATION_CLICK'
              },
              'notification': {
                'title': senderName.toString(),
                'body': _message.toString(),
                'icon': 'asset/images/Logo/logo.png',
              },
            }
        )
      );
       print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }
  subscribeToTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic('notify');
  }
}