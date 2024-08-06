

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotificationService {

  AndroidNotificationChannel myChannel (){
    return  const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
  }

  Future<String> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token!;
    //  print("NOTIFICATION TOKEN FOR LEGAL "+token);
  }

  void setUp( FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async{
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(myChannel());
  }
}