import 'dart:convert';
import 'dart:io';
import 'package:blueprint_app2/model/plan/plan_data.dart';
import 'package:blueprint_app2/services/blueprint_api_service.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as http_dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';
import 'payment_success.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, this.token, this.email}) : super(key: key);
  final String? token;
  final String? email;

  @override
  State<StatefulWidget> createState() {
    return _PaymentPageState();
  }
}

class _PaymentPageState extends State<PaymentPage> {
  ApiService _service = ApiService();
  http_dio.Dio dio = http_dio.Dio();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  static Variables variables = Variables();
  ColorClass colorClass = ColorClass();
  Color month = const Color(0xFFD3EBF7);
  Color year = const Color(0xFFFFFFFF);
  Color quarterly = const Color(0xFFFFFFFF);
  Color halfyear = const Color(0xFFFFFFFF);

  Color monthIc = const Color(0xFF1754BC);
  Color yearIc = const Color(0xFF1754BC);
  Color halfyearIc = const Color(0xFF1754BC);
  Color quarterlyIc = const Color(0xFF1754BC);
  static IconData unselectedIcon = Icons.panorama_fish_eye;
  static IconData selectedIcon = Icons.brightness_1;
  FirebaseAuth auth = FirebaseAuth.instance;

  IconData monthIcon = selectedIcon;
  IconData quarterlyIcon = unselectedIcon;
  IconData yearIcon = unselectedIcon;
  IconData halfyearIcon = unselectedIcon;
  String _cardNumber = '0000000000000000';
  String _cvv = '000';
  int _expiryMonth = 0;
  int _expiryYear = 0;

  bool _inProgress = false;
  bool _isCompleting = false;
  double? selectedAmount;
  PlanData? selectedPlanData;
  int duration = 0;
  PaystackPlugin _paystackPlugin = PaystackPlugin();
  int? conversionRate;

  @override
  void initState() {
    setUpUserFirebaseData();
    _paystackPlugin.initialize(publicKey: variables.paystackLiveKey);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: colorClass.appBlack,
        appBar: AppBar(
          backgroundColor: colorClass.appBlack,
          title: Text(''),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: colorClass.appBlack,
              child: Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(top: 30.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: colorClass.appWhite,
                        style: BorderStyle.solid,
                        width: 0.5),
                    color: colorClass.appWhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                child: ListView(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(10.0, 20.0, 30.0, 30.0),
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) => HomePage(
                                          token: widget.token!,
                                        )),
                                (Route<dynamic> route) => false);
                          },
                          child: Icon(
                            Icons.clear,
                            color: colorClass.appBlue,
                            size: 30.0,
                          ),
                        )),
                    SizedBox(height: 20.0),
                    Text(
                      variables.getAccessString,
                      style: TextStyle(
                          color: colorClass.appBlue,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Avenir',
                          fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      variables.premiumDescription,
                      style: TextStyle(
                          color: colorClass.appBlue,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Avenir',
                          fontSize: 13.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    FutureBuilder(
                      future: _service.getPaymentPlans(widget.token!),
                      builder: (context, planSnapshots) {
                        switch (planSnapshots.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                              child: Center(
                                child: Text(
                                  "Please wait...",
                                  style: TextStyle(
                                      color: colorClass.appWhite,
                                      fontSize: 18.0,
                                      fontFamily: 'Avenir',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                            break;
                          case ConnectionState.none:
                            return Container();
                            break;
                          case ConnectionState.active:
                            return Container();
                            break;
                          case ConnectionState.done:
                            if (planSnapshots.data != null) {
                              PlanData? plans = planSnapshots.data as PlanData?;
                              return planUI(plans!);
                            } else {
                              if (planSnapshots.hasError) {
                                String error = planSnapshots.error.toString();
                              }
                              return Container();
                            }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            _isCompleting ? loadingContainer() : Container()
          ],
        ));
  }

  Container planUI(PlanData plans) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 40.0),
              children: <Widget>[
                // monthly container
                GestureDetector(
                  onTap: () {
                    setState(() {
                      monthIc = colorClass.appBlue;
                      yearIc = colorClass.appBlue;
                      quarterlyIc = colorClass.appBlue;
                      halfyearIc = colorClass.appBlue;
                      quarterly = colorClass.appWhite;
                      month = colorClass.paymentLightBlue;
                      halfyear = colorClass.appWhite;
                      year = colorClass.appWhite;
                      monthIcon = selectedIcon;
                      yearIcon = unselectedIcon;
                      quarterlyIcon = unselectedIcon;
                      selectedAmount = double.parse(variables.monthlyPrice) *
                          conversionRate!;
                      selectedPlanData = plans;
                      duration = 1;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: colorClass.paymentLightBlue, width: 0.3),
                        borderRadius: BorderRadius.circular(0.0),
                        color: month,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                monthIcon,
                                color: monthIc,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                variables.monthly,
                                style: TextStyle(
                                    color: colorClass.appBlue,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Avenir',
                                    fontSize: 14.0),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "\$" + variables.monthlydiscount,
                                style: TextStyle(
                                    color: colorClass.appBlue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Avenir',
                                    fontSize: 13.0,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              SizedBox(width: 6.0),
                              Text(
                                "\$" + variables.monthlyPrice,
                                style: TextStyle(
                                    color: colorClass.appBlue,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Avenir',
                                    fontSize: 14.0),
                              ),
                            ],
                          )
                        ],
                      )),
                ),

                SizedBox(
                  height: 16.0,
                ),
                // quarterly container
                GestureDetector(
                  onTap: () {
                    setState(() {
                      monthIcon = unselectedIcon;
                      quarterlyIcon = selectedIcon;
                      halfyearIcon = unselectedIcon;
                      yearIcon = unselectedIcon;
                      monthIc = colorClass.appBlue;
                      yearIc = colorClass.appBlue;
                      halfyearIc = colorClass.appBlue;
                      quarterlyIc = colorClass.appBlue;
                      quarterly = colorClass.paymentLightBlue;
                      month = colorClass.appWhite;
                      year = colorClass.appWhite;
                      halfyear = colorClass.appWhite;
                      selectedAmount = double.parse(variables.quarterlyPrice) *
                          conversionRate!;
                      selectedPlanData = plans;
                      duration = 4;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: colorClass.paymentLightBlue, width: 0.3),
                        borderRadius: BorderRadius.circular(0.0),
                        color: quarterly,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                quarterlyIcon,
                                color: quarterlyIc,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                variables.quarterly,
                                style: TextStyle(
                                    color: colorClass.appBlue,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Avenir',
                                    fontSize: 14.0),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "\$" + variables.quarterlydiscount,
                                style: TextStyle(
                                    color: colorClass.appBlue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Avenir',
                                    fontSize: 13.0,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              SizedBox(width: 6.0),
                              Text(
                                "\$" + variables.quarterlyPrice,
                                style: TextStyle(
                                    color: colorClass.appBlue,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Avenir',
                                    fontSize: 14.0),
                              ),
                            ],
                          )
                        ],
                      )),
                ),

                SizedBox(
                  height: 16.0,
                ),
                // annual container
                GestureDetector(
                  onTap: () {
                    setState(() {
                      monthIcon = unselectedIcon;
                      quarterlyIcon = unselectedIcon;
                      yearIcon = selectedIcon;
                      halfyearIcon = unselectedIcon;
                      halfyearIc = colorClass.appBlue;
                      monthIc = colorClass.appBlue;
                      yearIc = colorClass.appBlue;
                      quarterlyIc = colorClass.appBlue;
                      quarterly = colorClass.appWhite;
                      halfyear = colorClass.appWhite;
                      month = colorClass.appWhite;
                      year = colorClass.paymentLightBlue;
                      // selectedAmount =
                      //     double.parse((355.99).toStringAsFixed(0)) * 480;
                      selectedAmount = double.parse(variables.annuallyPrice) *
                          conversionRate!;
                      selectedPlanData = plans;
                      duration = 12;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: colorClass.paymentLightBlue, width: 0.3),
                        borderRadius: BorderRadius.circular(0.0),
                        color: year,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                yearIcon,
                                color: yearIc,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                variables.annually,
                                style: TextStyle(
                                    color: colorClass.appBlue,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Avenir',
                                    fontSize: 14.0),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "\$" + variables.annualDiscount,
                                style: TextStyle(
                                    color: colorClass.appBlue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Avenir',
                                    fontSize: 13.0,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              SizedBox(width: 6.0),
                              Text(
                                "\$" + variables.annuallyPrice,
                                style: TextStyle(
                                    color: colorClass.appBlue,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Avenir',
                                    fontSize: 14.0),
                              ),
                            ],
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
          // Proceed button
          _inProgress
              ? Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Platform.isIOS
                      ? new CupertinoActivityIndicator()
                      : new CircularProgressIndicator(),
                )
              : GestureDetector(
                  onTap: () {
                    _startAfreshCharge();
//                       Navigator.of(context).pushAndRemoveUntil(
//                           MaterialPageRoute(builder: (BuildContext context) =>
//                               TestPayment()), (Route<dynamic> route) => false);
                  },
                  child: Container(
                    height: 50.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(30.0),
                      color: colorClass.appBlue,
                      elevation: 7.0,
                      child: Center(
                        child: Text(
                          variables.continueString,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                        ),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Container loadingContainer() {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.6),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text(
              'Completing request',
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

  _startAfreshCharge() async {
    Charge charge = Charge();
    charge.card = _getCardFromUI();
    double cost = selectedAmount! * 100;
    setState(() => _inProgress = true);

    charge
      ..amount = cost.round() // In base currency
      ..email = widget.email
      ..reference = _getReference();

    CheckoutResponse response = await _paystackPlugin.checkout(context,
        method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
        charge: charge);
    if (response.status == true) {
      setState(() {
        _inProgress = false;
        _isCompleting = true;
      });

      var request = await _service.paystackSubscriptionCallBack(
          widget.token!,
          selectedPlanData!.id.toString(),
          selectedAmount.toString(),
          variables.paystackLiveKey,
          response.reference!,
          duration);
      if (request.status!) {
        if (request.data != null) {
          _verifyOnServer(response.reference!);
          Map<String, dynamic> rawData = jsonDecode(jsonEncode(request.data));
          String message = rawData["message"];
        }
      }

      // _verifyOnServer(response.reference);
    } else {
      setState(() => _inProgress = false);
      _showMessage("Cancelled");
    }
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  String getDiscountPrice(String price, String discount) {
    var value = double.parse(discount);
    var cc = (value / 100) * double.parse(price);
    var tt = double.parse(price) - cc;
    return tt.toStringAsFixed(2);
  }

  String getDurationText(String duration) {
    var durationValue = int.parse(duration);
    if (durationValue == 1) {
      return duration + " " + variables.monthly;
    } else if (durationValue == 12) {
      return "1 Year";
    } else {
      return duration + " " + variables.months;
    }
  }

  void setUpUserFirebaseData() async {
    User? user = auth.currentUser;
    if (user != null) {
      DatabaseReference rate = FirebaseDatabase.instance
          .ref()
          .child("conversionRate")
          .child("dollar");
      try {
        final counterSnapshot = await rate.get();
        conversionRate = int.parse(counterSnapshot.value.toString());
        selectedAmount = double.parse(variables.monthlyPrice) * conversionRate!;
        print(
          'Connected to directly configured database and read '
          '${counterSnapshot.value}',
        );
      } catch (err) {
        print(err);
      }
    } else {}
  }

  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    ));
  }

  void _verifyOnServer(String reference) async {
    // _updateStatus(reference, 'Verifying...');
    String url = 'https://api.paystack.co/transaction/verify/$reference';
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        var signalHeaders = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + variables.paystackLiveKey
        };
        options.headers.addAll(signalHeaders);
        return handler.next(options);
      },
    ));

    try {
      http_dio.Response response = await dio.get(url);
      var body = response.data;
      _updateStatus(reference, body);
    } catch (e) {
      _updateStatus(
          reference,
          'There was a problem verifying %s on the backend: '
          '$reference $e');
    }
    setState(() => _isCompleting = false);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => Successpage(
                  token: widget.token!,
                  key: _scaffoldKey,
                )),
        (Route<dynamic> route) => false);
  }
}
