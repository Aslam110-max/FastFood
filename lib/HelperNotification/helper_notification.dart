/*import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HelperNotificatin{
  static Future<Void> initialization(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin)async{
     try {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { 
      print(message.data);
    });
  } catch (e) {
    print("Error is notification: "+e.toString());
  }
  var androidInitialize= new AndroidInitializationSettings("notification_icon");
  var initialize = new InitializationSettings(android: androidInitialize);
  
  FlutterLocalNotificationsPlugin.initialize(initialize,onDidReceiveNotificationResponse: (details) {
    print(details);
  },);
  }
}*/