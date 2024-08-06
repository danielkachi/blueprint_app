import 'dart:io';

import 'package:blueprint_app2/Admin/admin_home_page.dart';
import 'package:blueprint_app2/Admin/callbacks/new_signal_callback.dart';
import 'package:blueprint_app2/Admin/dialogs/add_signal_dialog.dart';
import 'package:blueprint_app2/model/signal/signal_data.dart';
import 'package:blueprint_app2/services/blueprint_admin_api_service.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_database/firebase_database.dart';

class AddSignalScreen extends StatefulWidget {
  const AddSignalScreen({Key? key, this.token}) : super(key: key);
  final String? token;

  @override
  _AddSignalScreenState createState() => _AddSignalScreenState();
}

class _AddSignalScreenState extends State<AddSignalScreen>
    implements DialogCallbacks {
  AdminApiService apiService = AdminApiService();
  static ColorClass colorClass = ColorClass();
  Variables variables = Variables();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController symbolController = TextEditingController();
  TextEditingController timeFrameController = TextEditingController();
  TextEditingController entryPrice1Controller = TextEditingController();
  TextEditingController entryPrice2Controller = TextEditingController();
  TextEditingController takeProfit1Controller = TextEditingController();
  TextEditingController takeProfit2Controller = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController tradeTypeController = TextEditingController();
  TextEditingController stoplossController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  CustomVariables customVariables = CustomVariables();
  NewSignals? newSignals;
  bool isSendingMessage = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: colorClass.appWhite,
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    Text('Add Signal',
                        style: TextStyle(
                            color: colorClass.youtubeBlue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SIGNAL NAME',
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 10.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.appBlack, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0),
                            color: colorClass.appWhite,
                          ),
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: symbolController,
                          ),
                        ),
                        SizedBox(height: 21.0),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variables.timeFrame.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 10.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.appBlack, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0),
                            color: colorClass.appWhite,
                          ),
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: timeFrameController,
                          ),
                        ),
                        SizedBox(height: 21.0),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variables.tradetype.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 10.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.appBlack, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0),
                            color: colorClass.appWhite,
                          ),
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: tradeTypeController,
                          ),
                        ),
                        SizedBox(height: 21.0),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variables.entryPrice1.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 10.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.appBlack, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0),
                            color: colorClass.appWhite,
                          ),
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: entryPrice1Controller,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                          ),
                        ),
                        SizedBox(height: 21.0),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variables.entryPrice2.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 10.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.appBlack, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0),
                            color: colorClass.appWhite,
                          ),
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: entryPrice2Controller,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                          ),
                        ),
                        SizedBox(height: 21.0),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variables.takeProfit1.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 10.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.appBlack, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0),
                            color: colorClass.appWhite,
                          ),
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: takeProfit1Controller,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                          ),
                        ),
                        SizedBox(height: 21.0),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variables.takeProfit2.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 10.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.appBlack, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0),
                            color: colorClass.appWhite,
                          ),
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: takeProfit2Controller,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                          ),
                        ),
                        SizedBox(height: 21.0),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variables.stopLoss.toUpperCase(),
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 10.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.appBlack, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0),
                            color: colorClass.appWhite,
                          ),
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: stoplossController,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                          ),
                        ),
                        SizedBox(height: 21.0),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variables.text.toUpperCase().toUpperCase(),
                            style: TextStyle(
                                color: colorClass.appBlack,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 10.0),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.appBlack, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0),
                            color: colorClass.appWhite,
                          ),
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: textController,
                            maxLines: 4,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 21.0),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      child: Center(
                        child: _image == null
                            ? Text('No image selected.')
                            : Image.file(_image!,
                                height: 230.0, fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(height: 17.0),
                    Row(children: <Widget>[
                      Text('Upload product picture',
                          style: TextStyle(
                              color: colorClass.appBlack,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Avenir')),
                      SizedBox(width: 20.0),
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          width: 101,
                          height: 50.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.appBlack, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0),
                            color: colorClass.appWhite,
                          ),
                          child: Center(
                            child: Text('Add file',
                                style: TextStyle(
                                    color: colorClass.youtubeBlue,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Avenir')),
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(height: 50.0),
                    GestureDetector(
                      onTap: () {
                        checkNewSignal(context);
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
                              'PREVIEW & ADD SIGNAL',
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
                )),
            isSendingMessage
                ? customVariables.loadingContainer(
                    "Adding Signal", colorClass.appWhite, true)
                : Container(),
          ],
        ));
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  void checkNewSignal(BuildContext buildcontext) {
    if (symbolController.text.isEmpty) {
      showMessage('Enter signal symbol');
      return;
    }
    if (timeFrameController.text.isEmpty) {
      showMessage('Enter signal time frame');
      return;
    }
    if (tradeTypeController.text.isEmpty) {
      showMessage('Enter signal Trade type');
      return;
    }
    // if (entryPrice1Controller.text == null ||
    //     entryPrice1Controller.text.isEmpty) {
    //   showMessage('Enter signal Entry price 1');
    //   return;
    // }
    // if (stoplossController.text == null || stoplossController.text.isEmpty) {
    //   showMessage('Enter signal stop loss');
    //   return;
    // }
    if (textController.text.isEmpty) {
      showMessage('Describe this signal');
      return;
    }

    String image = basename(_image!.path);
    newSignals = NewSignals(
        symbolController.text.toUpperCase(),
        timeFrameController.text.toUpperCase(),
        tradeTypeController.text.toUpperCase(),
        entryPrice1Controller.text,
        entryPrice2Controller.text,
        takeProfit1Controller.text,
        takeProfit2Controller.text,
        stoplossController.text,
        textController.text.toUpperCase(),
        "",
        "",
        image);

    Dialogs(this, scaffoldKey.currentContext!)
        .showMyDialog(_image!, newSignals!);
  }

  showMessage(String message) {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(new SnackBar(
      content: new Text(message),
      duration: Duration(seconds: 4),
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => ScaffoldMessenger.of(context as BuildContext)
              .removeCurrentSnackBar),
    ));
  }

  @override
  void onNegative(String message) {
    // TODO: implement onNegative
  }

  @override
  void onPositive(BuildContext buildcontext) async {
    setState(() {
      isSendingMessage = true;
    });
    sendFirebaseNotification();
    var response = await AdminApiService()
        .createSignal(widget.token!, _image!, newSignals!);
    if (response.status!) {
      setState(() {
        isSendingMessage = false;
      });
      Navigator.of(scaffoldKey.currentContext!).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => AdminHomePage(
                    token: widget.token!,
                  )),
          (Route<dynamic> route) => false);
    } else {
      setState(() {
        isSendingMessage = false;
      });
      showMessage("Operation failed");
    }
  }

  sendFirebaseNotification() async {
    DatabaseReference notificationRef =
        FirebaseDatabase.instance.reference().child("Signals");
    String? messageId = notificationRef.push().key;
    notificationRef.child(messageId!).set(newSignals!.toJson());
  }

  @override
  void onPasswordChanged(
      BuildContext context, String currentPassword, String newPassword) {
    // TODO: implement onPasswordChanged
  }
}
