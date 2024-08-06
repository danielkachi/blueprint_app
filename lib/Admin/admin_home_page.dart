import 'package:blueprint_app2/Admin/screens/account_screen.dart';
import 'package:blueprint_app2/Admin/screens/add_signal_screen.dart';
import 'package:blueprint_app2/Admin/screens/home_screen.dart';
import 'package:blueprint_app2/Admin/screens/message_screen.dart';
import 'package:blueprint_app2/custom_icons/blue_print_calendar_icons.dart';
import 'package:blueprint_app2/custom_icons/blueprint_trade_icons.dart';
import 'package:blueprint_app2/model/FirebaseUserModel.dart';
import 'package:blueprint_app2/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

import '../utils.dart';
import 'dialogs/log_out_dialog.dart';
import 'screens/signal_history_screen.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key, required this.token}) : super(key: key);
  final String token;

  @override
  State<StatefulWidget> createState() {
    WidgetsFlutterBinding.ensureInitialized();
    return _AdminHomeState();
  }
}

class _AdminHomeState extends State<AdminHomePage> {
  SharedPreferences? sharedPreferences;
  static ColorClass colorClass = ColorClass();
  static final scaffoldKey = new GlobalKey<ScaffoldState>();
  Variables variables = Variables();
  Widget? mainWidget;
  final SharedPref sharedPref = SharedPref();
  FirebaseAuth auth = FirebaseAuth.instance;

  String userToken = "";

  @override
  void initState() {
    super.initState();
    userToken = widget.token;
    mainWidget = HomeScreen(token: widget.token);
    setUpUserFirebaseData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: tradeAppBar(),
      body: mainWidget,
      drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: Container(
        color: colorClass.adminDarkBlue,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            DrawerHeader(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.clear,
                            color: colorClass.appWhite,
                            size: 25.0,
                          )),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child:
                                (Image.asset('assets/appic.png', scale: 0.5)),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            variables.appNameCap.toUpperCase(),
                            style: TextStyle(
                                fontSize: 27.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Avenir',
                                color: colorClass.appWhite,
                                letterSpacing: 3),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: colorClass.adminDarkBlue,
              ),
            ),
            ListTile(
              title: Text(
                'Home',
                style: TextStyle(color: colorClass.appWhite),
              ),
              leading: Icon(
                Icons.home,
                color: colorClass.youtubeBlue,
              ),
              onTap: () {
                // Update the state of the app
                setState(() {
                  mainWidget = HomeScreen(token: widget.token);
                });
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Add Signals',
                style: TextStyle(color: colorClass.appWhite),
              ),
              leading: Icon(
                BlueprintTrade.trade,
                color: colorClass.youtubeBlue,
              ),
              onTap: () {
                // Update the state of the app
                setState(() {
                  mainWidget = AddSignalScreen(token: widget.token);
                });
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Accounts',
                style: TextStyle(color: colorClass.appWhite),
              ),
              leading: Icon(
                Icons.person_outline,
                color: colorClass.youtubeBlue,
              ),
              onTap: () {
                setState(() {
                  mainWidget = AccountScreen(token: widget.token);
                });
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Messaging',
                style: TextStyle(color: colorClass.appWhite),
              ),
              leading: Icon(
                Icons.mail_outline,
                color: colorClass.youtubeBlue,
              ),
              onTap: () {
                setState(() {
                  mainWidget = MessageScreens(token: widget.token);
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Signal History',
                style: TextStyle(color: colorClass.appWhite),
              ),
              leading: Icon(
                BluePrintCalendar.calendar__1_,
                color: colorClass.youtubeBlue,
              ),
              onTap: () {
                setState(() {
                  mainWidget = SignalHistoryScreen(token: widget.token);
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(color: colorClass.appWhite),
              ),
              leading: Icon(
                Icons.power_settings_new,
                color: colorClass.youtubeBlue,
              ),
              onTap: () {
                // Update the state of the app
//                  sharedPref.clearAll();
//                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
                Navigator.pop(context);
                LogoutDialogs().showMyDialog(context);
              },
            ),
          ],
        ),
      )),
    );
  }

  static AppBar tradeAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: colorClass.appWhite,
      leading: Row(
        children: <Widget>[
          SizedBox(width: 10.0),
          Container(
            width: 35,
            height: 37,
            padding: EdgeInsets.all(3.0),
            child: (Image.asset('assets/appic.png',
                scale: 0.5, fit: BoxFit.fitHeight)),
          ),
        ],
      ),
      actions: <Widget>[
        GestureDetector(
          child: Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.all(2.0),
                child: (Image.asset('assets/hamburg.png', scale: 0.5)),
              ),
              SizedBox(width: 10.0)
            ],
          ),
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
      ],
    );
  }

  void setUpUserFirebaseData() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: "admin@equigro.com", password: Variables().adminPassword);
          updateFirebaseData();
          print('Sign in admin successful with firebase');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
        }
      } else {
        updateFirebaseData();
      }
    });
  }

  void getData() async {
    DatabaseReference rate =
        FirebaseDatabase.instance.ref().child("conversionRate").child("dollar");
    try {
      final counterSnapshot = await rate.get();
      int conversionRate = int.parse(counterSnapshot.value.toString());
      print(conversionRate);
    } catch (err) {
      print(err);
    }
  }

  updateFirebaseData() async {
    String? token = await FirebaseMessaging.instance.getToken();
    String useriId = auth.currentUser!.uid;
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child("Users");
    FirebaseUserModel userModel = FirebaseUserModel(token!, useriId);
    userRef.child(useriId).set(userModel.toJson());
  }
}
