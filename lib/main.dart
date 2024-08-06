import 'dart:io';

import 'package:blueprint_app2/services/navigation_service.dart';
import 'package:blueprint_app2/services/pushnotificationservice.dart';
import 'package:blueprint_app2/ui/screens/edit_profile_page.dart';
import 'package:blueprint_app2/ui/screens/home_page.dart';
import 'package:blueprint_app2/ui/screens/login_page.dart';
import 'package:blueprint_app2/ui/screens/notification_screen.dart';
import 'package:blueprint_app2/ui/screens/payment_ui.dart';
import 'package:blueprint_app2/ui/screens/signup_page.dart';
import 'package:blueprint_app2/ui/screens/splash_screen.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:overlay_support/overlay_support.dart';
import 'firebase_options.dart';
import 'package:logging/logging.dart';
import 'model/authentication/sign_in_response.dart';
import 'service_locator.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

onNotificationClick(String payload) {
  print('---- onNotificationClick ------------------');
  print(payload);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  _setupLogging();
  await Firebase.initializeApp();
  await initializeFlutterFire();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    WidgetsFlutterBinding.ensureInitialized();
    return _PageState();
  }
}

class _PageState extends State<MyApp> {
  SignInResponse? signInResponse;
  // FirebaseMessaging _firebaseMessaging;
  // AppNotificationService _appNotificationService = AppNotificationService();

  @override
  void initState() {
    // Firebase.initializeApp().whenComplete(() {
    setState(() {
      // _firebaseMessaging = FirebaseMessaging.instance;
      // FirebaseMessaging.onBackgroundMessage(
      //     _firebaseMessagingBackgroundHandler);
      // _appNotificationService.setUp(flutterLocalNotificationsPlugin);
      // FirebaseMessaging.instance
      //     .getInitialMessage()
      //     .then((RemoteMessage message) {
      //   print(message.data['title']);
      //   print(message.data['body']);
      // });
      // FirebaseMessaging.instance.getInitialMessage();
      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   print(message.notification.body);
      //   RemoteNotification notification = message.notification;
      //   AndroidNotification android = message.notification?.android;
      //   if (notification != null && android != null && !kIsWeb) {
      //     flutterLocalNotificationsPlugin.show(
      //         notification.hashCode,
      //         notification.title,
      //         notification.body,
      //         NotificationDetails(
      //           android: AndroidNotificationDetails(
      //               channel.id, channel.name, channel.description,
      //               // TODO add a proper drawable resource to android, for now using
      //               //      one that already exists in example app.
      //               icon: 'ic_launcher'),
      //         ));
      //   }
      // });

      // FirebaseMessaging.onMessageOpenedApp.listen((message) {
      //   print('A new onMessageOpenedApp event was published!');
      // });
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorClass colorClass = ColorClass();
    // final pushNotificationService = PushNotificationService(_firebaseMessaging);
    PushNotificationService().initialise();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return OverlaySupport(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: colorClass.appBlue),
      ),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: (routeSettings) {
        switch (routeSettings.name) {
          case 'Payment':
            return MaterialPageRoute(builder: (context) => PaymentPage());
          case 'Home':
            return MaterialPageRoute(builder: (context) => HomePage());
          case 'Notification':
            return MaterialPageRoute(
                builder: (context) => signInResponse == null
                    ? NotificationPage(
                        token: null,
                      )
                    : NotificationPage(
                        token: signInResponse!.bearer_token,
                      ));
          case 'Login':
            return MaterialPageRoute(builder: (context) => LoginPage());
          case 'SignUp':
            return MaterialPageRoute(builder: (context) => SignUpPage());
          case 'Edit Profile':
            return MaterialPageRoute(
                builder: (context) => signInResponse == null
                    ? EditProfilePage(
                        token: "",
                      )
                    : EditProfilePage(
                        token: signInResponse!.bearer_token,
                      ));
          default:
            return MaterialPageRoute(builder: (context) => HomePage());
        }
      },
    ));
  }
}

Future<void> initializeFlutterFire() async {
  var initSettingsAndroid;
  var initSettingsIos;
  var initSettings;
  if (Platform.isAndroid) {
    initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    initSettings = InitializationSettings(android: initSettingsAndroid);
  } else {
    initSettingsIos = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    initSettings = InitializationSettings(iOS: initSettingsIos);
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).whenComplete(
    () => flutterLocalNotificationsPlugin.initialize(
      initSettings,
      //     onSelectNotification: (String payload) async {
      //   onNotificationClick(payload);
      // },
    ),
  );
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}
