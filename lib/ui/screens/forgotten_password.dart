import 'package:blueprint_app2/model/authentication/sign_in_response.dart';
import 'package:blueprint_app2/service_locator.dart';
import 'package:blueprint_app2/services/blueprint_api_service.dart';
import 'package:blueprint_app2/services/navigation_service.dart';
import 'package:blueprint_app2/services/shared_pref.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgottenPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgottenPassword> {
  bool issendingLink = false;
  ApiService get service => GetIt.I<ApiService>();
  SignInResponse? signInResponse;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Variables variables = Variables();
  SharedPref sharedPref = SharedPref();
  ColorClass colorClass = ColorClass();
  SharedPreferences? sharedPreferences;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return new WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        return Navigator.of(context).maybePop();
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: colorClass.appBlack,
              leading: GestureDetector(
                onTap: () async {
                  sharedPref.clearAll();
                  locator<NavigationService>()
                      .navigateTo(new Variables().login);
                },
                child: Icon(
                  Icons.navigate_before,
                  color: colorClass.appWhite,
                ),
              )),
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
                  issendingLink
                      ? loadingContainer("Sending Recovery Link")
                      : Container(),
                ],
              ))),
    );
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

  Container headerSection() {
    return Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Center(
          child: Text('Forgot Password',
              style: TextStyle(
                  color: colorClass.appWhite,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Avenir',
                  fontSize: 25.0)),
        ));
  }

  Container textSection() {
    ColorClass colorClass = new ColorClass();
    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.only(top: 50.0),
      child: Column(
        children: <Widget>[
          Text(
            variables.forgotPasswordHint,
            style: TextStyle(
                color: colorClass.appWhite,
                fontWeight: FontWeight.w300,
                fontFamily: 'Avenir',
                fontSize: 13.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16.0,
          ),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                color: colorClass.appWhite,
                fontWeight: FontWeight.normal,
                fontFamily: 'Avenir',
                fontSize: 15.0),
            decoration: InputDecoration(
              hintText: 'Enter email address',
              hintStyle: TextStyle(color: colorClass.appGrey),
              labelText: 'Email address',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: colorClass.appWhite, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: BorderSide(color: colorClass.appWhite, width: 1.0),
              ),
              suffixIcon: Icon(
                Icons.alternate_email,
                color: colorClass.appGrey,
              ),
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Container bottomSection(BuildContext context) {
    ColorClass colorClass = new ColorClass();
    return Container(
        margin: EdgeInsets.only(top: 16.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: <Widget>[
          GestureDetector(
            onTap: () {
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
          ),
          SizedBox(height: 30.0),
        ]));
  }

  void sendRecoveryLink(BuildContext con) async {
    if (emailController.text.isEmpty) {
      _showMessage("Invalid email address");
    } else {
      setState(() {
        issendingLink = !issendingLink;
      });
      var response = await service.recoverPassword(emailController.text);
      emailController.clear();
      setState(() {
        issendingLink = !issendingLink;
      });
      //String data = response.data["message"];
      _showMessage("Recovery link sent successfully");
      Navigator.of(context).pop();
    }
  }

  TextEditingController emailController = new TextEditingController();

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
