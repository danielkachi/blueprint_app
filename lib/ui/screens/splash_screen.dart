import 'dart:async';
import 'dart:convert';

import 'package:blueprint_app2/Admin/admin_home_page.dart';
import 'package:blueprint_app2/model/authentication/sign_in_response.dart';
import 'package:blueprint_app2/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils.dart';
import 'home_page.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SignInResponse? signInResponse;
  SharedPref sharedPref = SharedPref();
  Variables variables = Variables();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));

    return Scaffold(
      backgroundColor: Color(0xFF000915),
      body: Center(
        child: Image.asset('assets/logowt.png'),
      ),
    );
  }

  void startTimer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 5));
    String? jWTtoken = '';
    jWTtoken = prefs.getString(variables.users);
    Map<String, dynamic> userData = jsonDecode(jWTtoken!);
    signInResponse = SignInResponse.fromJson(userData);
    if (signInResponse != null) {
      if (signInResponse!.role == "admin") {
        // return AdminHomePage(token: signInResponse.bearer_token);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  AdminHomePage(token: signInResponse!.bearer_token!)),
        );
      } else if (signInResponse!.role == "user") {
        //  return HomePage(token: signInResponse.bearer_token);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  HomePage(token: signInResponse!.bearer_token)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
      );
    }
    // Map<String, dynamic> userData =
    //     jsonDecode(prefs.getString(variables.users));
    // if (userData != null) {
    //   signInResponse = SignInResponse.fromJson(userData);
    //   if (signInResponse != null) {
    //     if (signInResponse.role == "admin") {
    //       // return AdminHomePage(token: signInResponse.bearer_token);
    //     } else if (signInResponse.role == "user") {
    //       //  return HomePage(token: signInResponse.bearer_token);
    //     } else {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
    //       );
    //     }
    //   } else {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
    //     );
    //   }
    // } else {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
    //   );
    // }
  }

  getCards() async {
    BuildContext context;
    String? jWTtoken = '';
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      jWTtoken = prefs.getString(variables.users);
      Map<String, dynamic> userData = jsonDecode(jWTtoken!);
      print(userData);
    } catch (e) {}
  }
}
/**
    return FutureBuilder(
    future: new SharedPref().read(new Variables().users),
    builder: (ctx, loginSnapshot) {
    switch (loginSnapshot.connectionState) {
    case ConnectionState.waiting:
    return SplashScreen();
    break;
    case ConnectionState.done:
    Map<String, dynamic> val = loginSnapshot.data;
    if (val != null) {
    signInResponse = SignInResponse.fromJson(val);
    if (signInResponse != null) {
    if (signInResponse.role == "admin") {
    return AdminHomePage(token: signInResponse.bearer_token);
    } else if (signInResponse.role == "user") {
    return HomePage(token: signInResponse.bearer_token);
    } else {
    return LoginPage();
    }
    } else {
    return LoginPage();
    }
    } else {
    return LoginPage();
    }
    break;
    case ConnectionState.active:
    return SplashScreen();
    break;
    case ConnectionState.none:
    return LoginPage();
    }
    return LoginPage();
    });
**/
