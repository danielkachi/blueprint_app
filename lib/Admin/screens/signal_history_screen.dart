import 'package:blueprint_app2/Admin/callbacks/new_signal_callback.dart';
import 'package:blueprint_app2/Admin/dialogs/confirm_dialog.dart';
import 'package:blueprint_app2/model/signal/signal_data.dart';
import 'package:blueprint_app2/services/blueprint_admin_api_service.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:flutter/material.dart';

class SignalHistoryScreen extends StatefulWidget {
  const SignalHistoryScreen({Key? key, this.token}) : super(key: key);
  final String? token;

  @override
  _SignalHistoryState createState() => _SignalHistoryState();
}

class _SignalHistoryState extends State<SignalHistoryScreen>
    implements DialogCallbacks {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  AdminApiService apiService = AdminApiService();
  static ColorClass colorClass = ColorClass();
  Variables variables = Variables();
  CustomVariables customVariables = CustomVariables();
  TextEditingController searchController = TextEditingController();
  List<Signals>? allSignals;
  List<Signals> _filteredList = [];
  String filter = "";
  bool isDeleting = false;
  Signals? selectedSignal;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          filter = "";
          _filteredList = allSignals!;
        });
      } else {
        setState(() {
          filter = searchController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: colorClass.appWhite,
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    Text('Signal History',
                        style: TextStyle(
                            color: colorClass.youtubeBlue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.0),
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: colorClass.appGrey, width: 0.3),
                        borderRadius: BorderRadius.circular(4.0),
                        color: colorClass.appWhite,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                            controller: searchController,
                            style: TextStyle(color: colorClass.appBlack),
                            decoration: InputDecoration(
                              labelText: "Search by symbols or trade type",
                              labelStyle: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.normal,
                                  color: colorClass.appGrey),
                            ),
                          )),
                          SizedBox(width: 10.0),
                          Icon(
                            Icons.search,
                            color: colorClass.youtubeBlue,
                            size: 25.0,
                          ),
                          SizedBox(width: 10.0),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.0),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.youtubeBlue,
                                style: BorderStyle.solid,
                                width: 0.5),
                            color: colorClass.youtubeBlue,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0))),
                        height: 41.0,
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Signals',
                              style: TextStyle(
                                  color: colorClass.appWhite,
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Avenir')),
                        )),
                    SizedBox(height: 10.0),
                    Container(
                      child: FutureBuilder(
                          future: apiService.getSignalsHistory(widget.token!),
                          builder: (context, responseSnashot) {
                            switch (responseSnashot.connectionState) {
                              case ConnectionState.waiting:
                                return customVariables.lightLoadingContainer(
                                    '', colorClass.appGrey, true);
                                break;
                              case ConnectionState.done:
                                if (responseSnashot.data != null) {
                                  allSignals =
                                      responseSnashot.data as List<Signals>?;
                                  if ((filter.isNotEmpty)) {
                                    List<Signals>? tmpList;
                                    for (int i = 0;
                                        i < _filteredList.length;
                                        i++) {
                                      if (_filteredList[i]
                                              .symbol!
                                              .toLowerCase()
                                              .contains(filter.toLowerCase()) ||
                                          _filteredList[i]
                                              .trade_type!
                                              .toLowerCase()
                                              .contains(filter.toLowerCase())) {
                                        tmpList!.add(_filteredList[i]);
                                      }
                                    }
                                    _filteredList = tmpList!;
                                  } else {
                                    _filteredList = allSignals!;
                                  }
                                  return itemContainer(_filteredList);
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
                  ],
                )),
            isDeleting
                ? customVariables.loadingContainer(
                    "Deleting Signal", colorClass.appWhite, true)
                : Container(),
          ],
        ));
  }

  ListView itemContainer(List<Signals> signals) {
    return ListView.builder(
      itemCount: allSignals == null ? 0 : _filteredList.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
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
                          constraints: BoxConstraints(maxWidth: 100),
                          child: Text(
                            signals[index].trade_type == null
                                ? 'nil' // Provide a string value as a default if trade_type is null
                                : signals[index]
                                    .trade_type
                                    .toString(), // Convert trade_type to string explicitly
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
                            ? Text("nil")
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
                            ? Text("nil")
                            : Text(signals[index].take_profit_one!,
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
                            ? Text("nil")
                            : Text(signals[index].stop_loss!,
                                style: TextStyle(
                                    color: colorClass.appBlack,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400)),
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
                            ? Text("nil")
                            : Text(signals[index].entry_price_one!,
                                style: TextStyle(
                                    color: colorClass.appBlack,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400)),
                        SizedBox(height: 27.0),
                        signals[index].take_profit_two == null
                            ? Container()
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
                                color: signals[index].status == "1"
                                    ? colorClass.adminLightGreen
                                    : colorClass.appRed),
                            SizedBox(width: 10.0),
                            Text(
                                customVariables
                                    .getSignalStatus(signals[index].status!),
                                style: TextStyle(
                                    color: colorClass.appBlack,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(width: 0.0),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              GestureDetector(
                onTap: () {
                  selectedSignal = signals[index];
                  ConfirmDialog(this, scaffoldKey.currentContext!)
                      .showMyDialog(context);
                },
                child: Container(
                    height: 41.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: colorClass.adminRed,
                            style: BorderStyle.solid,
                            width: 0.5),
                        color: colorClass.adminRed,
                        borderRadius: BorderRadius.circular(5.0)),
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        'Delete Signal',
                        style: TextStyle(
                            color: colorClass.appWhite,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Avenir'),
                        textAlign: TextAlign.center,
                      ),
                    )),
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

  @override
  void onNegative(String message) {
    // TODO: implement onNegative
    selectedSignal = null;
    _showMessage("Operation cancelled");
  }

  @override
  void onPasswordChanged(
      BuildContext context, String currentPassword, String newPassword) {
    // TODO: implement onPasswordChanged
  }

  @override
  void onPositive(BuildContext context) async {
    setState(() {
      isDeleting = true;
    });
    var response =
        await AdminApiService().deleteSignal(widget.token!, selectedSignal!.id);
    if (response != null) {
      if (response.status!) {
        setState(() {
          isDeleting = false;
        });
        selectedSignal = null;
        _showMessage("Operation successful");
      } else {
        _showMessage("Service unavailable");
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(message),
      duration: Duration(seconds: 2),
      action: new SnackBarAction(
          label: 'CLOSE',
          disabledTextColor: colorClass.adminRed,
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    ));
  }
}
