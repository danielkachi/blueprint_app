import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Variables {
  int conversionRate = 500;
  String appName = "Blueprint";
  String appNameCap = "BLUEPRINT";
  String trade = 'Trade';
  String tradeParam = 'TRADE PARAMETER';
  String tradeHistory = 'Trade History';
  String feedback = 'Feedbacks';
  String profile = 'Profile';
  String symbol = 'Symbol';
  String timeFrame = 'Time Frame';
  String tradetype = 'Trade type / Order type';
  String entryPrice1 = 'Entry Price 1';
  String entryPrice2 = 'Entry Price 2';
  String takeProfit1 = 'Take Profit 1';
  String takeProfit2 = 'Take Profit 2';
  String date = 'Date';
  String emptyString = ' ';
  String showmore = 'Show more';
  String showless = 'Show less';
  String stopLoss = 'Stop Loss';
  String time = 'Time';
  String status = 'Status';
  String active = 'Active';
  String inactive = 'Inactive';
  String text = 'Signal Description';
  String getAccessString = 'Get Access to our premium features';
  String premiumDescription =
      "Hey! Let's take you on this route with us... The journey to your financial freedom begins with one click. What are you waiting for?...";
  String monthly = 'Monthly';
  String months = 'Months';
  String quarterly = 'Quarterly (4 months)';
  String annually = 'Annually';
  String monthlyPrice = '29.99';
  String quarterlyPrice = '99.99';
  String annuallyPrice = '299.99';
  String monthlydiscount = '150';
  String quarterlydiscount = '600';
  String annualDiscount = '1800';
  String continueString = 'CONTINUE';
  String successText =
      'Your monthly subscription has been successfully activated.';
  String success = 'Successful';
  String payment = 'Payment';
  String home = 'Home';
  String notification = 'Notification';
  String login = "Login";
  String signUp = 'SignUp';
  String users = 'Users';
  String editProfile = 'Edit Profile';
  String failed = 'Failed';
  String appPassword = "AppPassword";
  String adminPassword = "upperCases2022";
  String imagebaseLink = 'https://equigro.org/storage/signal/';
  String userImageLink = 'https://equigro.org/storage/user-photo/';
  String ravePublicKEy = 'FLWPUBK_TEST-0ef091a1ad8f627e6d1211e92d1fdec0-X';
  String paystackPublicKey = 'pk_test_fa0223d996e42adbeec656f09460ee030ca4a18d';
  String paystackLiveKey = 'pk_live_6f32d2b866d0744c489c705c3a9f67edf78e4034';
  String forgotPasswordHint =
      "It's ok to forget, we've got you covered. Enter your registered email address and a link will be sent to your mail to help reset your password";
//   Account name = Test Account Name
//   card date = 09/23
//   card Number = 408 408 0000000 409
//   card CVV = 000
}

class ColorClass {
  Color appBlue = const Color(0xFF1754BC);
  Color appWhite = const Color(0xFFFFFFFF);
  Color appBlack = const Color(0xFF000915);
  Color youtubeBlue = const Color(0xFF219CD7);
  Color paymentLightBlue = const Color(0xFFD3EBF7);
  Color appGrey = const Color(0xFFC6C5C4);
  Color appRed = const Color(0xFFFF0000);

  // admin section colors
  Color adminDarkBlue = const Color(0xFF000746);
  Color adminLightGreen = const Color(0xFF2DCE98);
  Color adminRed = const Color(0xFFF53C56);
  Color adminLightBlue = const Color(0xFF11CDEF);
  Color adminPurple = const Color(0xFF24419C);
}

class CustomVariables {
  String convertCurrentDateToString() {
    DateTime dt = DateTime.now();
    String formattedDate = DateFormat.yMMMMd('en_US').format(dt);
    return formattedDate;
  }

  String formatedDate(String dateString) {
    DateTime signalDate = DateTime.parse(dateString);
    //String formattedDate = DateFormat('yyyy-MM-dd').format(signalDate);
    //return formatDate(signalDate, [yyyy, '/', mm, '/', dd, '', hh, ':', nn, ':', ss, '', am]);
    String formattedDate = DateFormat.yMMMMd('en_US').format(signalDate);
    return formattedDate;
  }

  String getSignalStatus(String status) {
    if (status == "1") {
      return new Variables().active;
    } else {
      return new Variables().inactive;
    }
  }

  Color getStatusColor(String status) {
    if (status == "1") {
      return ColorClass().adminLightGreen;
    } else {
      return ColorClass().appRed;
    }
  }

  Container pleaseWaitText() {
    return Container(
      child: Text(
        'Please wait',
        style: TextStyle(
            color: new ColorClass().appWhite,
            fontSize: 15.0,
            fontWeight: FontWeight.w300,
            fontFamily: 'Avenir'),
      ),
    );
  }

  Container loadingContainer(
      String title, Color titleColor, bool showPleaseWait) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.6),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text(
              title,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Avenir'),
            ),
            showPleaseWait
                ? Text(
                    'Please wait',
                    style: TextStyle(
                        color: titleColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Avenir'),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Container lightLoadingContainer(
      String title, Color titleColor, bool showPleaseWait) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Avenir'),
            ),
            showPleaseWait
                ? Text(
                    'Please wait',
                    style: TextStyle(
                        color: titleColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Avenir'),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Text plainText(String title, Color colors) {
    return Text(
      title,
      style: TextStyle(
          color: colors,
          fontWeight: FontWeight.normal,
          fontFamily: 'Avenir',
          fontSize: 15.0),
    );
    }

  TextFormField passwordForm(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      cursorColor: new ColorClass().appBlack,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      style: TextStyle(
          fontFamily: 'Avenir',
          fontWeight: FontWeight.normal,
          color: new ColorClass().appBlack),
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(
            fontFamily: 'Avenir',
            fontWeight: FontWeight.normal,
            color: new ColorClass().appGrey),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: new ColorClass().appGrey)),
      ),
    );
  }

  _launchMainSite() async {
    const url = "https://equigro.org/forgot";
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true); //forceWebView
    } else {
      throw 'Could not launch $url';
    }
  }
}
