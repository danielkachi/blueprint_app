import 'package:blueprint_app2/model/signal/signal_data.dart';
import 'package:blueprint_app2/model/user/user_profile.dart';
import 'package:blueprint_app2/services/blueprint_api_service.dart';
import 'package:blueprint_app2/ui/screens/home_page.dart';
import 'package:blueprint_app2/ui/screens/payment_ui.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:flutter/material.dart';

import '../screens/signal_view.dart';

class TradeHistory {
  ApiService _apiService = ApiService();
  ColorClass colorClass = ColorClass();
  Variables variables = Variables();
  CustomVariables customVariables = CustomVariables();

  List<String> spinnerItems = [
    'FILTER BY DATE',
    'FILTER BY TIME',
  ];

  String dropdownValue = 'FILTER BY DATE';

  Container historyContainer(
      Profile? profile, BuildContext context, String token) {
    if (profile != null) {
      if (profile.active_subscription) {
        return mainBody(context, token, profile.profile!);
      } else {
        return errorContainer(context, token, profile.profile!);
      }
    } else {
      return errorContainer(context, token, profile!.profile!);
    }
  }

  Container mainBody(
      BuildContext context, String apptoken, UserProfile profile) {
    return Container(
      child: Column(
        children: <Widget>[
          headerSection(context),
          itemContentHeader(),
          FutureBuilder(
            future: _apiService.getSignalsFromApi(apptoken),
            builder: (BuildContext buildcontext, signalSnapshot) {
              switch (signalSnapshot.connectionState) {
                case ConnectionState.none:
                  return loadingContainer();
                  break;
                case ConnectionState.waiting:
                  return loadingContainer();
                  break;
                case ConnectionState.active:
                  return loadingContainer();
                  break;
                case ConnectionState.done:
                  if (signalSnapshot.hasError) {
                    return networkErrorContainer(
                        context, 'Something went wrong');
                  } else {
                    if (signalSnapshot.data == null) {
                      return networkErrorContainer(
                          context, 'No Transactions today');
                    } else {
                      HomePage.of(context)!.allSignals =
                          signalSnapshot.data as List<Signals>?;
                      if ((HomePage.of(context)!.filter.isNotEmpty)) {
                        List<Signals>? tmpList;
                        for (int i = 0;
                            i < HomePage.of(context)!.filteredList.length;
                            i++) {
                          if (HomePage.of(context)!
                                  .filteredList[i]
                                  .symbol!
                                  .toLowerCase()
                                  .contains(HomePage.of(context)!
                                      .filter
                                      .toLowerCase()) ||
                              HomePage.of(context)!
                                  .filteredList[i]
                                  .trade_type!
                                  .toLowerCase()
                                  .contains(HomePage.of(context)!
                                      .filter
                                      .toLowerCase())) {
                            tmpList!.add(HomePage.of(context)!.filteredList[i]);
                          }
                        }
                        HomePage.of(context)!.filteredList = tmpList!;
                      } else {
                        HomePage.of(context)!.filteredList =
                            HomePage.of(context)!.allSignals!;
                      }
                      return itemBody(
                          HomePage.of(context)!.filteredList, context);
                    }
                  }
                  break;
              }
              return Container();
            },
          )
        ],
      ),
    );
  }

  Container loadingContainer() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Container errorContainer(
      BuildContext context, String apptoken, UserProfile profile) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 120.0),
          Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'No Transactions today',
                    style: TextStyle(
                      color: colorClass.appWhite,
                      fontSize: 15.0,
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  new GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentPage(
                                  token: apptoken,
                                  email: profile.email,
                                )),
                      );
                    },
                    child: Text(
                      'Subscribe to unlock trade features',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: colorClass.appBlue,
                          fontWeight: FontWeight.w300,
                          fontSize: 15.0),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container headerSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 15),
      color: colorClass.appBlue,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            decoration: BoxDecoration(
              border: Border.all(color: colorClass.appGrey, width: 0.3),
              borderRadius: BorderRadius.circular(10.0),
              color: colorClass.appWhite,
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  onFieldSubmitted: (text) {
                    HomePage.of(context)!.performSearch();
                  },
                  controller: HomePage.of(context)!.searchController,
                  style: TextStyle(color: colorClass.appBlack),
                  decoration: InputDecoration(
                    labelText: "Search by symbol or status",
                    labelStyle: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.normal,
                        color: colorClass.appGrey),
                  ),
                )),
                SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () {
                    HomePage.of(context)!.performSearch();
                  },
                  child: Icon(
                    Icons.search,
                    color: colorClass.youtubeBlue,
                    size: 25.0,
                  ),
                ),
                SizedBox(width: 10.0),
              ],
            ),
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }

  Container itemContentHeader() {
    return Container(
      color: colorClass.appBlack,
      padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 70.0,
            child: Text(
              variables.symbol,
              style: TextStyle(
                color: colorClass.appWhite,
                fontSize: 15.0,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 70.0,
            child: Text(
              variables.status,
              style: TextStyle(
                color: colorClass.appWhite,
                fontSize: 15.0,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: 100.0,
            child: Text(
              variables.time,
              style: TextStyle(
                color: colorClass.appWhite,
                fontSize: 15.0,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container itemBody(List<Signals> signalsList, BuildContext context) {
    return Container(
        child: Expanded(
      child: ListView.builder(
          reverse: true,
          itemCount: HomePage.of(context)!.allSignals == null
              ? 0
              : HomePage.of(context)!.filteredList.length,
          itemBuilder: (context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignalView(
                            signal: signalsList[index],
                          )),
                );
              },
              child: itemContent(signalsList[index]),
            );
          }),
    ));
  }

  Container itemContent(Signals signals) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 70.0,
            child: Text(
              signals.symbol!,
              style: TextStyle(
                color: colorClass.appWhite,
                fontSize: 15.0,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Container(
            width: 70.0,
            child: Text(
              customVariables.getSignalStatus(signals.status!),
              style: TextStyle(
                color: colorClass.appWhite,
                fontSize: 15.0,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Container(
            width: 100.0,
            child: Text(
              customVariables.formatedDate(signals.created_at!),
              style: TextStyle(
                color: colorClass.appWhite,
                fontSize: 15.0,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
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
                HomePage.of(context)!.changeState(1);
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
