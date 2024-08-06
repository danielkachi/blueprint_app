import 'dart:convert';
import 'dart:io';
import 'package:blueprint_app2/Admin/admin_home_page.dart';
import 'package:blueprint_app2/custom_icons/blue_print_lock_icons.dart';
import 'package:blueprint_app2/model/api_response.dart';
import 'package:blueprint_app2/model/authentication/sign_in_response.dart';
import 'package:blueprint_app2/services/blueprint_api_service.dart';
import 'package:blueprint_app2/services/shared_pref.dart';
import 'package:blueprint_app2/ui/screens/forgotten_password.dart';
import 'package:blueprint_app2/ui/screens/home_page.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signup_page.dart';
import 'video_viewer.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool issendingLink = false;
  ApiService get service => GetIt.I<ApiService>();
  SignInResponse? signInResponse;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _obscureText = true;
  Variables variables = Variables();
  SharedPref sharedPref = SharedPref();
  ColorClass colorClass = ColorClass();
  SharedPreferences? sharedPreferences;
  FirebaseAuth auth = FirebaseAuth.instance;

  var _border = new Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        _exitApp();
        return Future.value(false);
      },
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color.fromRGBO(0, 9, 21, 1),
          body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/gg.png'),
                fit: BoxFit.contain,
              )),
              child: Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      headerSection(),
                      textSection(),
                      bottomSection(context),
                    ],
                  ),
                  _isLoading ? loadingContainer("") : Container(),
                  issendingLink ? loadingContainer("") : Container(),
                ],
              ))),
    );
  }

  void _exitApp() {
    if (Platform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
  }

  Container loadingContainer(String titleString) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.6),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text(
              titleString,
              style: TextStyle(
                  color: colorClass.appWhite,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Avenir'),
            ),
            Text(
              'Please wait',
              style: TextStyle(
                  color: colorClass.appWhite,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Avenir'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void setUpUserFirebaseData() {
    User user = auth.currentUser!;
    print('User should be signed out');
    auth.signOut();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setUpUserFirebaseData();
    // if (sharedPreferences.getString("token") != null) {
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(
    //           builder: (BuildContext context) => HomePage(
    //                 token: sharedPreferences.getString("token"),
    //               )),
    //       (Route<dynamic> route) => false);
    // }

    // if (auth.currentUser != null){
    //   auth.signOut();
    // }
  }

  Container headerSection() {
    return Container(
        padding: EdgeInsets.only(top: 40.0),
        child: Center(
          child: Image(
            image: AssetImage('assets/llogo.png'),
          ),
        ));
  }

  Container textSection() {
    ColorClass colorClass = new ColorClass();
    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.only(top: 50.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: usernameController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              icon: Icon(Icons.person_outline, color: Colors.white),
              labelText: "Username",
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorClass.appGrey)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorClass.appGrey, width: 0.5),
              ),
              labelStyle: TextStyle(
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.normal,
                  color: colorClass.appGrey),
            ),
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  obscureText: _obscureText,
                  controller: passwordController,
                  cursorColor: Colors.white,
                  style: TextStyle(
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(BluePrintLock.lock, color: Colors.white),
                    labelText: "Password",
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorClass.appGrey)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: colorClass.appGrey, width: 0.5),
                    ),
                    labelStyle: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.normal,
                        color: colorClass.appGrey),
                  ),
                  validator: (val) =>
                      val!.length < 6 ? 'Password too short.' : null,
                ),
              ),
              GestureDetector(
                child: Icon(
                  Icons.remove_red_eye,
                  color: colorClass.appGrey,
                  size: 20.0,
                ),
                onTap: () {
                  _toggle();
                },
              )
            ],
          ),
          SizedBox(height: 30.0),
          Container(
              alignment: Alignment(1.0, 0.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgottenPassword()),
                  );
                },
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void showForgotPassword() {
    _scaffoldKey.currentState?.showBottomSheet((context) => Container(
          height: 260,
          decoration: BoxDecoration(
              border: Border.all(
                color: colorClass.appWhite,
                style: BorderStyle.solid,
                width: 0.5,
              ),
              color: colorClass.appWhite,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Forgot Password',
                  style: TextStyle(
                      color: colorClass.appBlack,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Avenir',
                      fontSize: 25.0)),
              SizedBox(height: 20.0),
              TextFormField(
                controller: recoverPasswordController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    color: colorClass.appBlack,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Avenir',
                    fontSize: 15.0),
                decoration: InputDecoration(
                  hintText: 'Enter email address',
                  labelText: 'Email',
                  errorText: 'A recovery link will be sent to this email',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.error,
                    color: colorClass.appGrey,
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  sendRecoveryLink(context);
                },
                child: Container(
                    height: 41.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: colorClass.youtubeBlue,
                            style: BorderStyle.solid,
                            width: 0.5),
                        color: colorClass.youtubeBlue,
                        borderRadius: BorderRadius.circular(5.0)),
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        'Recover password',
                        style: TextStyle(
                            color: colorClass.appWhite,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Avenir'),
                        textAlign: TextAlign.center,
                      ),
                    )),
              )
            ],
          ),
        ));
  }

  Container bottomSection(BuildContext context) {
    ColorClass colorClass = new ColorClass();
    return Container(
        margin: EdgeInsets.only(top: 16.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: <Widget>[
          GestureDetector(
            onTap: () {
              login();
            },
            child: Container(
              height: 50.0,
              width: 172.0,
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: colorClass.appBlue,
                color: colorClass.appBlue,
                elevation: 7.0,
                child: Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Not setup yet?',
                  style: TextStyle(color: colorClass.appGrey)),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, variables.login);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child:
                    new Text('Signup', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 70.0),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VideoViewer()));
              },
              child: Text('Watch intro video',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: colorClass.youtubeBlue,
                    fontSize: 18.0,
                  )),
            ),
          )
        ]));
  }

  void sendRecoveryLink(BuildContext con) async {
    if (recoverPasswordController.text.isEmpty) {
      _showMessage("Invalid email address");
      Navigator.pop(con);
    } else {
      setState(() {
        issendingLink = !issendingLink;
      });

      var response =
          await service.recoverPassword(recoverPasswordController.text);
      recoverPasswordController.clear();
      setState(() {
        issendingLink = !issendingLink;
      });
      String data = response.data["message"];
      _showMessage(data);
      Navigator.pop(con);
    }
  }

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController recoverPasswordController = new TextEditingController();

  void login() async {
    if (usernameController.text == "") {
      _showMessage("Please enter your username");
      return;
    }

    if (passwordController.text == "") {
      _showMessage("Please enter a valid password");
      return;
    }

    setState(() {
      _isLoading = true;
    });
    ApiResponse response = await service.loginUser(
        usernameController.text, passwordController.text);
    if (response.status!) {
      Map<String, dynamic> responseData =
          json.decode(jsonEncode(response.data));
      SignInResponse signInResponse = SignInResponse();
      signInResponse.username = responseData["username"];
      signInResponse.bearer_token = responseData["bearer_token"];
      signInResponse.role = responseData["role"];
      setState(() {
        _isLoading = false;
      });
      if (signInResponse.bearer_token == null) {
        _showMessage('Incorrect credentials');
      } else {
        //sharedPreferences.setString(variables.login, responseData["bearer_token"]);
        sharedPref.save(variables.users, signInResponse);
        if (signInResponse.role == 'admin') {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      AdminHomePage(token: responseData["bearer_token"])),
              (Route<dynamic> route) => false);
        } else {
          sharedPreferences!
              .setString(variables.appPassword, passwordController.text);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(
                        token: responseData["bearer_token"],
                        password: passwordController.text,
                      )),
              (Route<dynamic> route) => false);
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _showMessage(response.data);
    }
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(message),
      duration: Duration(seconds: 4),
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    ));
  }
}
