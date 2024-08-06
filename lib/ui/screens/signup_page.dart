import 'package:blueprint_app2/custom_icons/blue_print_call_icons.dart';
import 'package:blueprint_app2/custom_icons/blue_print_email_icons.dart';
import 'package:blueprint_app2/custom_icons/blue_print_lock_icons.dart';
import 'package:blueprint_app2/custom_icons/blue_print_refer_icons.dart';
import 'package:blueprint_app2/model/api_response.dart';
import 'package:blueprint_app2/model/authentication/sign_up.dart';
import 'package:blueprint_app2/services/blueprint_api_service.dart';
import 'package:blueprint_app2/ui/screens/home_page.dart';
import 'package:blueprint_app2/ui/screens/login_page.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'video_viewer.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Variables variables = Variables();
  ColorClass colorClass = ColorClass();
  ApiService service = ApiService();
  bool isLoading = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _obscureText = true;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromRGBO(0, 9, 21, 70.0),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/gg.png'), fit: BoxFit.contain)),
            child: Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    headerSection(),
                    textSection(),
                    bottomSection(context),
                  ],
                ),
                isLoading ? loadingContainer() : Container()
              ],
            )));
  }

  void showBottom(SignUpResponse signUpResponse) {
    _scaffoldKey.currentState?.showBottomSheet((cont) => Container(
          height: 180,
          decoration: BoxDecoration(
              border: Border.all(
                  color: colorClass.appWhite,
                  style: BorderStyle.solid,
                  width: 0.5),
              color: colorClass.appWhite,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Play intro video',
                  style: TextStyle(
                      color: colorClass.appBlack,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Avenir',
                      fontSize: 19.0)),
              SizedBox(height: 20.0),
              Text(
                "Watch an introductory video about blueprint. To know what it's all about ",
                style: TextStyle(
                    color: colorClass.appBlack,
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Avenir'),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(cont);
                        },
                        child: Text('Skip',
                            style: TextStyle(
                                color: colorClass.youtubeBlue,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Avenir',
                                fontSize: 17.0)),
                      ),
                    ],
                  ),
                  SizedBox(width: 30.0),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(cont);
                          Navigator.push(
                              cont,
                              MaterialPageRoute(
                                  builder: (cont) => VideoViewer()));
                        },
                        child: Text('Play now',
                            style: TextStyle(
                                color: colorClass.youtubeBlue,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Avenir',
                                fontSize: 17.0)),
                      ),
                      SizedBox(width: 10.0),
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Container headerSection() {
    return Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Center(
          child: Image(
            image: AssetImage('assets/llogo.png'),
          ),
        ));
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.only(top: 30.0),
      child: Column(
        children: <Widget>[
          textFormSetup('Username', Icons.person_outline, usernameController),
          SizedBox(height: 16.0),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            cursorColor: colorClass.appWhite,
            style: TextStyle(color: colorClass.appWhite),
            decoration: InputDecoration(
              icon: Icon(BluePrintCall.call,
                  color: colorClass.appWhite, size: 20),
              hintText: 'Phone no',
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorClass.appGrey)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorClass.appGrey, width: 0.5),
              ),
              hintStyle: TextStyle(
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.normal,
                  color: colorClass.appGrey),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: colorClass.appWhite,
            style: TextStyle(color: colorClass.appWhite),
            decoration: InputDecoration(
              icon: Icon(BluePrintEmail.email,
                  color: colorClass.appWhite, size: 20),
              hintText: 'Email Address',
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorClass.appGrey)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorClass.appGrey, width: 0.5),
              ),
              hintStyle: TextStyle(
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.normal,
                  color: colorClass.appGrey),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: sponsorController,
            keyboardType: TextInputType.number,
            cursorColor: colorClass.appWhite,
            style: TextStyle(color: colorClass.appWhite),
            decoration: InputDecoration(
              icon: Icon(BluePrintRefer.refer,
                  color: colorClass.appWhite, size: 20),
              hintText: 'Sponsor code (Optional)',
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorClass.appGrey)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorClass.appGrey, width: 0.5),
              ),
              hintStyle: TextStyle(
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.normal,
                  color: colorClass.appGrey),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: passwordController,
                  cursorColor: colorClass.appWhite,
                  style: TextStyle(
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.normal,
                      color: colorClass.appWhite),
                  decoration: InputDecoration(
                    icon: Icon(
                      BluePrintLock.lock,
                      color: colorClass.appWhite,
                      size: 23.0,
                    ),
                    hintText: "Password",
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: colorClass.appGrey)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: colorClass.appGrey, width: 0.5),
                    ),
                    hintStyle: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.normal,
                        color: colorClass.appGrey),
                  ),
                  validator: (val) =>
                      val!.length < 6 ? 'Password too short.' : null,
                  obscureText: _obscureText,
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
          SizedBox(height: 16.0),
          TextFormField(
            controller: confirmPasswordController,
            cursorColor: colorClass.appWhite,
            style: TextStyle(
                fontFamily: 'Avenir',
                fontWeight: FontWeight.normal,
                color: colorClass.appWhite),
            decoration: InputDecoration(
              icon: Icon(
                BluePrintLock.lock,
                color: colorClass.appWhite,
                size: 23.0,
              ),
              hintText: "Confirm password",
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: colorClass.appGrey)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorClass.appGrey, width: 0.5),
              ),
              hintStyle: TextStyle(
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.normal,
                  color: colorClass.appGrey),
            ),
            obscureText: _obscureText,
          ),
        ],
      ),
    );
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Container bottomSection(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 30.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: <Widget>[
          GestureDetector(
            onTap: () {
              registerUser();
            },
            child: Container(
              height: 50.0,
              width: 172.0,
              child: Material(
                  borderRadius: BorderRadius.circular(23.0),
                  color: colorClass.appBlue,
                  elevation: 7.0,
                  child: Center(
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                  )),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('already have an account?',
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Avenir')),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                      (Route<dynamic> route) => false);
                },
                child: Text('Login',
                    style: TextStyle(
                        color: colorClass.appWhite,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Avenir',
                        fontSize: 15.0)),
              )
            ],
          ),
          SizedBox(height: 50.0),
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

  TextFormField textFormSetup(
      String hintText, IconData icon, TextEditingController textController) {
    return TextFormField(
      controller: textController,
      cursorColor: colorClass.appWhite,
      style: TextStyle(color: colorClass.appWhite),
      decoration: InputDecoration(
        icon: Icon(icon, color: colorClass.appWhite, size: 20),
        hintText: hintText,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorClass.appGrey)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorClass.appGrey, width: 0.5),
        ),
        hintStyle: TextStyle(
            fontFamily: 'Avenir',
            fontWeight: FontWeight.normal,
            color: colorClass.appGrey),
      ),
    );
  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController sponsorController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  Container loadingContainer() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.6),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text(
              'Creating your account',
              style: TextStyle(
                  color: colorClass.appWhite,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Avenir'),
            ),
            Text(
              "Please wait",
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

  void registerUser() async {
    if (usernameController.text == "") {
      _showMessage("Please enter your username");
      return;
    }
    if (emailController.text == "") {
      _showMessage("Please enter your email");
      return;
    }

    if (passwordController.text == "") {
      _showMessage("Please enter a valid password");
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _showMessage("Please ensure passwords match");
      return;
    }

    // try {
    //   final result = await InternetAddress.lookup('example.com');
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //
    //   }
    // } on SocketException catch (_) {
    //   _showMessage('Check Internet connections');
    // }
    registerAction();
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

  registerAction() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    SignUpRequest signUpRequest = SignUpRequest();
    signUpRequest.phone = phoneController.text;
    signUpRequest.sponsor_code = sponsorController.text;
    signUpRequest.username = usernameController.text;
    signUpRequest.email = emailController.text;
    signUpRequest.password = passwordController.text;
    ApiResponse? response = await service.registerUser(signUpRequest);
    if (response.status!) {
      setState(() {
        isLoading = false;
      });
      SignUpResponse signUpResponse = SignUpResponse.fromJson(response.data);
      if (signUpResponse.token == null) {
        _showMessage(signUpResponse.message!);
      } else {
        setUpUserFirebaseData();
        sharedPreferences.setString(variables.login, signUpResponse.token!);
        sharedPreferences.setString(
            variables.appPassword, passwordController.text);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => HomePage(
                      token: signUpResponse.token,
                      password: passwordController.text,
                    )),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        isLoading = false;
      });

      if (response.data.toString().toLowerCase() == "found") {
        _showMessage('The email is registered to another user');
      } else {
        _showMessage(response.data.toString());
      }
    }
  }

  void setUpUserFirebaseData() {
    User? user = auth.currentUser;
    if (user == null) {
      print('User is signed out');
    } else {
      print('User should be signed out');
      auth.signOut();
    }
  }
}
