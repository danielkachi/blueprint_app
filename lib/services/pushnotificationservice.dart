import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class PushNotificationService {
  // final FirebaseMessaging _fcm;

  // PushNotificationService(this._fcm);
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future initialise() async {
    if (Platform.isIOS) {
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
        // TODO: handle the received notifications
      } else {
        print('User declined or has not accepted permission');
      }
    }

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String? token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
      RemoteNotification notificationData = message.notification!;
      showSimpleNotification(
        NotificationBody(
            title: notificationData.title!, body: notificationData.body!),
        contentPadding:
            EdgeInsets.only(bottom: 20.0, top: 20.0, left: 20.0, right: 20.0),
        background: Colors.transparent,
        autoDismiss: false,
      );
      print('done:');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // checkForInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
      var body = message.data["body"];
      var title = message.data["title"];
      RemoteNotification notificationData = message.notification!;

      showSimpleNotification(
        NotificationBody(
            title: title ?? notificationData.title,
            body: body ?? notificationData.body),
        contentPadding:
            EdgeInsets.only(bottom: 20.0, top: 20.0, left: 20.0, right: 20.0),
        background: Colors.transparent,
        autoDismiss: false,
      );
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("onBackgroundMessagenotification: ${message.notification?.body}");

  print("onBackgroundMessagedata: ${message.data}");

  print("onMessageOpenedApp: ${message}");

  var body = message.data["body"];

  var title = message.data["title"];

  showSimpleNotification(
    NotificationBody(title: title, body: body),
    contentPadding:
        EdgeInsets.only(bottom: 20.0, top: 20.0, left: 20.0, right: 20.0),
    background: Colors.transparent,
    autoDismiss: false,
  );
}

checkForInitialMessage() async {
  RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  print("initialMessagenotification: ${message?.notification}");
  print("initialMessagedata: ${message?.data}");
  RemoteNotification? notificationData = message?.notification;

  var body = message!.data["body"];
  var title = message.data["title"];

  showSimpleNotification(
    NotificationBody(
        title: title ?? message.notification?.title,
        body: body ?? message.notification?.body),
    contentPadding:
        EdgeInsets.only(bottom: 20.0, top: 20.0, left: 20.0, right: 20.0),
    background: Colors.transparent,
    autoDismiss: false,
  );
  // showSimpleNotification(
  //   Container(child: Text(message.data['title'])),
  //   position: NotificationPosition.top,
  //   subtitle: Text(message.data['body ']),
  //   background: Colors.cyan.shade700,
  //   duration: Duration(seconds: 2),
  // );
}

class NotificationBody extends StatelessWidget {
  const NotificationBody({
    this.title,
    this.body,
  });

  final String? title;

  final String? body;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        int sensitivity = 8;
        if (details.delta.dy > sensitivity) {
          print('down');
        } else if (details.delta.dy < -sensitivity) {
          print('up');
          OverlaySupportEntry.of(context)?.dismiss();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding:
              EdgeInsets.only(bottom: 20.0, top: 20.0, left: 5.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/appic.png",
                  height: 45,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   height: 15,
                        // ),
                        Text(
                          title ?? '',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      body ?? '',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              Builder(builder: (context) {
                return InkWell(
                    onTap: () {
                      OverlaySupportEntry.of(context)?.dismiss();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ));
              })
            ],
          ),
        ),
      ),
    );
  }
}
