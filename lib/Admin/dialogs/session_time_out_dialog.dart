import 'package:blueprint_app2/services/shared_pref.dart';
import 'package:blueprint_app2/ui/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils.dart';

class SessionDialogs {
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
              'Session Time out',
              textScaleFactor: 1,
              // textScaler: TextScaler.linear(1),
            ),
            content: SingleChildScrollView(
              // won't be scrollable
              child: Text(
                  'Your session has timed out please re-login to continue?',
                  textScaleFactor: 1),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text('Login'),
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
