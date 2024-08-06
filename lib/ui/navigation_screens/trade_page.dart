import 'dart:io';

import 'package:blueprint_app2/model/signal/signal_data.dart';
import 'package:blueprint_app2/model/user/user_profile.dart';
import 'package:blueprint_app2/services/blueprint_api_service.dart';
import 'package:blueprint_app2/ui/screens/home_page.dart';
import 'package:blueprint_app2/ui/screens/signal_view.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import '../screens/image_viewer.dart';
import '../screens/payment_ui.dart';

class TradePage {
  ApiService _apiService = ApiService();
  SharedPreferences? sharedPreferences;
  ColorClass colorClass = ColorClass();
  Variables variables = Variables();

  Widget pageContainer(
      Profile userProfile, String token, BuildContext context) {
    return profileBody(token, userProfile, context);
  }

  Future<String> getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences!.getString("Login") != null) {
      String? token = sharedPreferences!.getString("Login");
      return token!;
    }
    return "";
  }

  Container errorContainer(BuildContext context, String token, String email) {
    return Container(
        child: ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(height: 200.0),
        Container(
          child: Image.asset(
            'assets/error.png',
            height: 230.0,
            width: 250.0,
          ),
        ),
        SizedBox(height: 30.0),
        Container(
          alignment: Alignment.center,
          child: Text(
            'No Transactions',
            style: TextStyle(
              color: colorClass.appWhite,
              fontSize: 15.0,
              fontFamily: 'Avenir',
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentPage(
                          token: token,
                          email: email,
                        )),
              );
            },
            child: Text(
              'Subscribe to unlock trade features',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: colorClass.appBlue,
                  fontWeight: FontWeight.w200,
                  fontSize: 15.0),
            ),
          ),
        )
      ],
    ));
  }

  Widget mainBody(Profile userProfile, String token, BuildContext context) {
    return UpgradeAlert(
      dialogStyle: Platform.isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      // countryCode: '+234',
      // debugDisplayAlways: true,
      // durationToAlertAgain: Duration(days: 1),
      child: Container(
        child: Stack(
          children: <Widget>[
            headerSection(userProfile.profile!.username!),
            userProfile.active_subscription
                ? tradeBody(userProfile.profile!, token, context)
                : errorContainer(context, token, userProfile.profile!.email!),
          ],
        ),
      ),
    );
  }

  Container headerSection(String username) {
    return Container(
      height: 150.0,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      color: colorClass.appBlue,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Welcome',
              style: TextStyle(
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.w300,
                  color: colorClass.appWhite,
                  fontSize: 15.0),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.bottomLeft,
            child: Text(
              username,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                  color: colorClass.appWhite,
                  fontFamily: 'Avenir'),
            ),
          ),
        ],
      ),
    );
  }

  Container tradeBody(
      UserProfile userProfile, String token, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: FutureBuilder(
        future: _apiService.getSignalsFromApi(token),
        builder: (BuildContext context, AsyncSnapshot<List<Signals>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
              break;
            case ConnectionState.waiting:
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
              break;
            case ConnectionState.active:
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
              break;
            case ConnectionState.done:
              if (snapshot.hasError) {
                return networkErrorContainer(context, 'Something went wrong');
              } else {
                if (snapshot.data == null) {
                  return networkErrorContainer(
                      context, 'No Signal at the moment');
                } else {
                  List<Signals> listData = snapshot.data!;
                  List<Signals> list = [];
                  if (listData.length > 0) {
                    for (Signals sn in listData) {
                      if (list.length < 25) {
                        list.insert(0, sn);
                      }
                    }
                    return _signalData(list);
                  } else {
                    return _signalData(listData);
                  }
                }
              }
              break;
          }
          return Container();
        },
      ),
    );
  }

  Widget profileBody(String token, Profile? userProfile, BuildContext context) {
    if (userProfile != null) {
      return mainBody(userProfile, token, context);
    } else {
      return Container(
        child: Center(
          child: Text(
            'Check your internet connections',
            style: TextStyle(
                color: colorClass.appWhite,
                fontSize: 8.0,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  Swiper _signalData(List<Signals> signals) {
    return Swiper(
      itemCount: signals.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ImageViewer(image: signals[index].image)),
                );
              },
              child: Container(
                height: 200.0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: signalImage(signals[index].image!, context),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            formatedDate(signals[index].created_at!),
                            style: TextStyle(
                                color: colorClass.appWhite,
                                fontWeight: FontWeight.normal,
                                fontSize: 10.0),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Latest Analysis',
                                style: TextStyle(
                                    color: colorClass.appWhite,
                                    fontSize: 10.0,
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Icon(
                                Icons.lens,
                                color: colorClass.appRed,
                                size: 10.0,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: GestureDetector(
                  child: Text(
                    'View all parameters',
                    style: TextStyle(
                        color: colorClass.appWhite,
                        fontSize: 18.0,
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignalView(
                                signal: signals[index],
                              )),
                    );
                  }),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 22.0),
                  Divider(
                    height: 30.0,
                    color: colorClass.appGrey,
                  ),
                  itemsContainer(variables.symbol, signals[index].symbol!),
                  Divider(
                    height: 30.0,
                    color: colorClass.appGrey,
                  ),
                  itemsContainer(
                      variables.timeFrame, signals[index].time_frame!),
                  Divider(
                    height: 30.0,
                    color: colorClass.appGrey,
                  ),
                  signals[index].trade_type != null
                      ? itemsContainer(
                          variables.tradetype, signals[index].trade_type!)
                      : Container(),
                  Divider(
                    height: 30.0,
                    color: colorClass.appGrey,
                  ),
                  signals[index].entry_price_one != null
                      ? itemsContainer(variables.entryPrice1,
                          signals[index].entry_price_one!)
                      : Container(),
                  Divider(
                    height: 30.0,
                    color: Colors.grey[800],
                  ),
                  signals[index].entry_price_two != null
                      ? itemsContainer(variables.entryPrice2,
                          signals[index].entry_price_two!)
                      : Container(),
                  SizedBox(height: 20.0),
//                   Text(signals[index].text, style: TextStyle(color: Colors.white,
//                       fontSize: 15.0,
//                       fontFamily: 'Avenir',
//                       fontWeight: FontWeight.normal),)
                ],
              ),
            )
          ],
        );
      },
      viewportFraction: 0.9,
      itemWidth: 300,
      scale: 0.9,
      loop: false,
    );
  }

  Image signalImage(String image, BuildContext cont) {
    return Image.network(variables.imagebaseLink + image,
        height: 200.0,
        width: MediaQuery.of(cont).size.width,
        fit: BoxFit.fitWidth);
    //https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png
  }

  String formatedDate(String dateString) {
    DateTime signalDate = DateTime.parse(dateString);
    //String formattedDate = DateFormat('yyyy-MM-dd').format(signalDate);
    //return formatDate(signalDate, [yyyy, '/', mm, '/', dd, '', hh, ':', nn, ':', ss, '', am]);
    String formattedDate = DateFormat.yMMMMd('en_US').format(signalDate);
    return formattedDate;
  }

  Container itemsContainer(String label, String value) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10.0),
              Text(
                label,
                style: TextStyle(
                  color: colorClass.appWhite,
                  fontSize: 8.0,
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 7.0),
              Text(
                value,
                style: TextStyle(
                    color: colorClass.appWhite,
                    fontSize: 13.0,
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void copyValue(String value) {
    Clipboard.setData(ClipboardData(text: value));
  }

  Container networkErrorContainer(BuildContext context, String errorMessage) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              errorMessage,
              style: TextStyle(
                  color: colorClass.appWhite,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Avenir'),
            ),
            GestureDetector(
              onTap: () {
                HomePage.of(context)!.changeState(0);
              },
              child: Center(
                child: Text(
                  'Try again later',
                  style: TextStyle(
                      color: colorClass.appWhite,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Avenir'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
