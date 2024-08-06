import 'package:blueprint_app2/services/shared_pref.dart';
import 'package:blueprint_app2/ui/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils.dart';

class LogoutDialogs {
  ColorClass colorClass = ColorClass();
  Variables variables = Variables();
  FirebaseAuth auth = FirebaseAuth.instance;

  void showMyDialog(BuildContext context) async {
    SharedPref sharedPref = SharedPref();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Logout',
              textScaleFactor: 1,
            ),
            content: SingleChildScrollView(
              // won't be scrollable
              child:
                  Text('Are you sure you want to log out?', textScaleFactor: 1),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    sharedPref.clearAll();
                    if (auth.currentUser != null) {
                      auth.signOut();
                    }
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage()),
                        (Route<dynamic> route) => false);
                  }),
            ],
          );
        });
  }
}
