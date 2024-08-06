import 'package:blueprint_app2/custom_icons/blueprint_trade_icons.dart';
import 'package:blueprint_app2/model/signal/signal_data.dart';
import 'package:blueprint_app2/services/blueprint_admin_api_service.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.token}) : super(key: key);
  final String? token;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AdminApiService apiService = AdminApiService();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  static ColorClass colorClass = ColorClass();
  CustomVariables customVariables = CustomVariables();
  Variables variables = Variables();
  int setCount = 0;
  String showMoreText = "Show more";
  List<Signals>? apiResponse;
  static String? userToken;
  bool isWaiting = false;

  @override
  void initState() {
    super.initState();
    userToken = widget.token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: colorClass.appWhite,
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Text('Home',
                  style: TextStyle(
                      color: colorClass.youtubeBlue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.adminLightGreen,
                                style: BorderStyle.solid,
                                width: 0.5),
                            color: colorClass.adminLightGreen,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SUCCESFUL SIGNALS',
                                    style: TextStyle(
                                        color: colorClass.appWhite,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 10.0),
                                FutureBuilder(
                                    future: apiService
                                        .getSuccessfulSignals(widget.token!),
                                    builder: (context, responseSnashot) {
                                      switch (responseSnashot.connectionState) {
                                        case ConnectionState.waiting:
                                          return customVariables
                                              .pleaseWaitText();
                                          break;
                                        case ConnectionState.active:
                                          return customVariables
                                              .pleaseWaitText();
                                          break;
                                        case ConnectionState.done:
                                          if (responseSnashot.data != null) {
                                            String? apiResponse =
                                            responseSnashot.data as String?;
                                            return Text(
                                              apiResponse ?? '', // Use null-aware operator to handle null case
                                              style: TextStyle(
                                                color: colorClass.appWhite,
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            );
                                          } else {
                                            if (responseSnashot.hasError) {
                                              return Text('0',
                                                  style: TextStyle(
                                                      color:
                                                          colorClass.appWhite,
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.w400));
                                            }
                                          }
                                          break;
                                        case ConnectionState.none:
                                          // TODO: Handle this case.
                                          break;
                                      }
                                      return Text('0',
                                          style: TextStyle(
                                              color: colorClass.appWhite,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w400));
                                    })
                              ],
                            ),
                            SizedBox(width: 10.0),
                            Icon(Icons.trending_up, color: colorClass.appWhite)
                          ],
                        )),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.adminRed,
                                style: BorderStyle.solid,
                                width: 0.5),
                            color: colorClass.adminRed,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TOTAL USERS',
                                    style: TextStyle(
                                        color: colorClass.appWhite,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 10.0),
                                FutureBuilder(
                                    future:
                                        apiService.getTotalUsers(widget.token!),
                                    builder: (context, responseSnashot) {
                                      switch (responseSnashot.connectionState) {
                                        case ConnectionState.waiting:
                                          return customVariables
                                              .pleaseWaitText();
                                          break;
                                        case ConnectionState.active:
                                          return customVariables
                                              .pleaseWaitText();
                                          break;
                                        case ConnectionState.done:
                                          if (responseSnashot.data != null) {
                                            String apiResponse =
                                                responseSnashot.data as String;
                                            return Text(apiResponse,
                                                style: TextStyle(
                                                    color: colorClass.appWhite,
                                                    fontSize: 11.0,
                                                    fontWeight:
                                                        FontWeight.w400));
                                          } else {
                                            if (responseSnashot.hasError) {
                                              return Text('0',
                                                  style: TextStyle(
                                                      color:
                                                          colorClass.appWhite,
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.w400));
                                            }
                                          }
                                          break;
                                        case ConnectionState.none:
                                          // TODO: Handle this case.
                                          break;
                                      }
                                      return Text('0',
                                          style: TextStyle(
                                              color: colorClass.appWhite,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w400));
                                    }),
                              ],
                            ),
                            SizedBox(width: 20.0),
                            Icon(Icons.person_outline,
                                color: colorClass.appWhite)
                          ],
                        )),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.adminPurple,
                                style: BorderStyle.solid,
                                width: 0.5),
                            color: colorClass.adminPurple,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ACTIVE SUBSCRIBERS',
                                    style: TextStyle(
                                        color: colorClass.appWhite,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 10.0),
                                FutureBuilder(
                                    future: apiService
                                        .getActiveSubscribers(widget.token!),
                                    builder: (context, responseSnashot) {
                                      switch (responseSnashot.connectionState) {
                                        case ConnectionState.waiting:
                                          return customVariables
                                              .pleaseWaitText();
                                          break;
                                        case ConnectionState.active:
                                          return customVariables
                                              .pleaseWaitText();
                                          break;
                                        case ConnectionState.done:
                                          if (responseSnashot.data != null) {
                                            String apiResponse =
                                                responseSnashot.data as String;
                                            return Text(apiResponse,
                                                style: TextStyle(
                                                    color: colorClass.appWhite,
                                                    fontSize: 11.0,
                                                    fontWeight:
                                                        FontWeight.w400));
                                          } else {
                                            if (responseSnashot.hasError) {
                                              return Text('0',
                                                  style: TextStyle(
                                                      color:
                                                          colorClass.appWhite,
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.w400));
                                            }
                                          }
                                          break;
                                        case ConnectionState.none:
                                          // TODO: Handle this case.
                                          break;
                                      }
                                      return Text('0',
                                          style: TextStyle(
                                              color: colorClass.appWhite,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w400));
                                    }),
                              ],
                            ),
                            SizedBox(width: 10.0),
                            Icon(Icons.attach_money, color: colorClass.appWhite)
                          ],
                        )),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.adminLightBlue,
                                style: BorderStyle.solid,
                                width: 0.5),
                            color: colorClass.adminLightBlue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TOTAL SIGNALS',
                                    style: TextStyle(
                                        color: colorClass.appWhite,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 10.0),
                                FutureBuilder(
                                    future: apiService
                                        .getTotalSignals(widget.token!),
                                    builder: (context, responseSnashot) {
                                      switch (responseSnashot.connectionState) {
                                        case ConnectionState.waiting:
                                          return customVariables
                                              .pleaseWaitText();
                                          break;
                                        case ConnectionState.active:
                                          return customVariables
                                              .pleaseWaitText();
                                          break;
                                        case ConnectionState.done:
                                          if (responseSnashot.data != null) {
                                            String apiResponse =
                                                responseSnashot.data as String;
                                            return Text(apiResponse,
                                                style: TextStyle(
                                                    color: colorClass.appWhite,
                                                    fontSize: 11.0,
                                                    fontWeight:
                                                        FontWeight.w400));
                                          } else {
                                            if (responseSnashot.hasError) {
                                              return Text('0',
                                                  style: TextStyle(
                                                      color:
                                                          colorClass.appWhite,
                                                      fontSize: 11.0,
                                                      fontWeight:
                                                          FontWeight.w400));
                                            }
                                          }
                                          break;
                                        case ConnectionState.none:
                                          // TODO: Handle this case.
                                          break;
                                      }
                                      return Text('0',
                                          style: TextStyle(
                                              color: colorClass.appWhite,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w400));
                                    }),
                              ],
                            ),
                            SizedBox(width: 8.0),
                            Icon(BlueprintTrade.trade,
                                color: colorClass.appWhite, size: 20)
                          ],
                        )),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Container(
                  height: 41.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: colorClass.youtubeBlue,
                          style: BorderStyle.solid,
                          width: 0.5),
                      color: colorClass.youtubeBlue,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0))),
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('LIVE SIGNALS',
                        style: TextStyle(
                            color: colorClass.appWhite,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Avenir')),
                  )),
              SizedBox(height: 10.0),
              Container(
                child: FutureBuilder(
                    future: apiService.getLiveSignals(widget.token!),
                    builder: (context, responseSnashot) {
                      switch (responseSnashot.connectionState) {
                        case ConnectionState.waiting:
                          return customVariables.lightLoadingContainer(
                              '', colorClass.appGrey, true);
                          break;
                        case ConnectionState.done:
                          if (responseSnashot.data != null) {
                            apiResponse = responseSnashot.data as List<Signals>?;
                            setCount = apiResponse!.length;
                            return itemContainer(apiResponse!);
                          } else {
                            if (responseSnashot.hasError) {
                              return Container();
                            } else {
                              return Container();
                            }
                          }
                        case ConnectionState.none:
                          // TODO: Handle this case.
                          break;
                        case ConnectionState.active:
                          // TODO: Handle this case.
                          break;
                      }
                      return Container();
                    }),
              ),
              SizedBox(height: 5.0),
              setCount > 3
                  ? Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                          onTap: () {
                            if (showMoreText == variables.showmore) {
                              setState(() {
                                setCount = apiResponse!.length;
                                showMoreText = variables.showless;
                              });
                            } else {
                              setState(() {
                                setCount = 3;
                                showMoreText = variables.showmore;
                              });
                            }
                          },
                          child: Text(showMoreText,
                              style: TextStyle(
                                  color: colorClass.appBlack,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Avenir'))),
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: setCount < 3
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                if (showMoreText == variables.showmore) {
                                  setState(() {
                                    setCount = apiResponse!.length;
                                    showMoreText = variables.showless;
                                  });
                                } else {
                                  setState(() {
                                    setCount = 3;
                                    showMoreText = variables.showmore;
                                  });
                                }
                              },
                              child: Text(showMoreText,
                                  style: TextStyle(
                                      color: colorClass.appBlack,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Avenir'))),
                    )
            ],
          ),
        ));
  }

  ListView itemContainer(List<Signals> signals) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: setCount,
      padding: EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        return Container(
          color: colorClass.appWhite,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variables.symbol.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.youtubeBlue,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        Text(signals[index].symbol!,
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 27.0),
                        Text(variables.tradetype.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.youtubeBlue,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        Container(
                          //width: MediaQuery.of(context).size.width /2,
                          constraints: BoxConstraints(maxWidth: 100),
                          child: Text(
                            signals[index].trade_type == null
                                ? 'nil'
                                : signals[index].trade_type.toString(), // Cast to String using toString()
                            style: TextStyle(
                              color: colorClass.appBlack,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 3,
                          ),
                        ),
                        SizedBox(height: 27.0),
                        signals[index].entry_price_two == null
                            ?  Text("nil")
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(variables.entryPrice2.toUpperCase(),
                                      style: TextStyle(
                                          color: colorClass.youtubeBlue,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10.0),
                                  Text(signals[index].entry_price_two!,
                                      style: TextStyle(
                                          color: colorClass.appBlack,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(height: 27.0),
                                ],
                              ),
                        Text(variables.takeProfit1.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.youtubeBlue,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        signals[index].take_profit_one == null
                            ?  Text("nil"):
                        Text(signals[index].take_profit_one!,
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 27.0),
                        Text(variables.stopLoss.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.youtubeBlue,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        signals[index].stop_loss == null
                            ?  Text("nil"):
                        Text(signals[index].stop_loss!,
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 27.0),
                        GestureDetector(
                          onTap: () {
                            addToSuccess(signals[index].id!);
                          },
                          child: Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: colorClass.adminLightGreen,
                                      style: BorderStyle.solid,
                                      width: 0.5),
                                  color: colorClass.adminLightGreen,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Center(
                                child: isWaiting
                                    ? Text("Please wait",
                                        style: TextStyle(
                                            color: colorClass.appWhite,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400))
                                    : Text(variables.success,
                                        style: TextStyle(
                                            color: colorClass.appWhite,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400)),
                              )),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variables.timeFrame.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.youtubeBlue,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        Text(signals[index].time_frame!,
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 27.0),
                        Text(variables.entryPrice1.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.youtubeBlue,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        signals[index].entry_price_one == null
                            ?  Text("nil"):
                        Text(signals[index].entry_price_one!,
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 27.0),
                        signals[index].take_profit_two == null
                            ? Text("nil")
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(variables.takeProfit2.toUpperCase(),
                                      style: TextStyle(
                                          color: colorClass.youtubeBlue,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10.0),
                                  Text(signals[index].take_profit_two!,
                                      style: TextStyle(
                                          color: colorClass.appBlack,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(height: 27.0),
                                ],
                              ),
                        Text(variables.date.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.youtubeBlue,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        Container(
                          //width: MediaQuery.of(context).size.width /2,
                          constraints: BoxConstraints(maxWidth: 100),
                          child: Text(
                            customVariables
                                .formatedDate(signals[index].created_at!),
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400),
                            maxLines: 3,
                          ),
                        ),
                        SizedBox(height: 27.0),
                        Text(variables.status.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.youtubeBlue,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            Icon(Icons.fiber_manual_record,
                                size: 11.0,
                                color: customVariables
                                    .getStatusColor(signals[index].status!)),
                            SizedBox(width: 5.0),
                            Text(
                                customVariables
                                    .getSignalStatus(signals[index].status!),
                                style: TextStyle(
                                    color: colorClass.appBlack,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                        SizedBox(height: 27.0),
                        GestureDetector(
                          onTap: () {
                            addToFailed(signals[index].id!);
                          },
                          child: Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: colorClass.appRed,
                                      style: BorderStyle.solid,
                                      width: 0.5),
                                  color: colorClass.appRed,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Center(
                                child: isWaiting
                                    ? Text("Please wait",
                                        style: TextStyle(
                                            color: colorClass.appWhite,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400))
                                    : Text(variables.failed,
                                        style: TextStyle(
                                            color: colorClass.appWhite,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400)),
                              )),
                        )
                      ],
                    ),
                    SizedBox(width: 0.0),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Divider(
                color: colorClass.youtubeBlue,
                height: 20.0,
                thickness: 1.0,
              ),
            ],
          ),
        );
      },
    );
  }

  void addToSuccess(String signalId) async {
    setState(() {
      isWaiting = true;
    });
    var response = await apiService.successfulApi(widget.token!, signalId);
    if (response.status!) {
      setState(() {
        isWaiting = false;
      });
      _showMessage("Operation successful");
    }
    }

  void addToFailed(String signalId) async {
    setState(() {
      isWaiting = true;
    });
    var response = await apiService.failedApi(widget.token!, signalId);
    if (response.status!) {
      setState(() {
        isWaiting = false;
      });
      _showMessage("Operation successful");
    }
    }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(message),
      duration: Duration(seconds: 2),
      action: new SnackBarAction(
          label: 'CLOSE',
          disabledTextColor: colorClass.adminRed,
          onPressed: () => ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    ));
  }
}
