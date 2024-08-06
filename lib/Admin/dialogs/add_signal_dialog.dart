import 'dart:io';
import 'package:blueprint_app2/Admin/callbacks/new_signal_callback.dart';
import 'package:blueprint_app2/model/signal/signal_data.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';

class Dialogs {
  ColorClass colorClass = ColorClass();
  Variables variables = Variables();
  CustomVariables customVariables = CustomVariables();
  DialogCallbacks newSignalCallback;
  BuildContext buildContext;

  Dialogs(this.newSignalCallback, this.buildContext);

  void showMyDialog(File imgPath, NewSignals signals) {
    showDialog(
        // (context: context,builder: (dialogContex){
        context: buildContext,
        builder: (dialogContex) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10.0),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(dialogContex);
                    },
                    child: Icon(
                      Icons.clear,
                      color: colorClass.youtubeBlue,
                      size: 24.0,
                    ),
                  )),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        imgPath == null
                            ? Image.asset('assets/lion.jpeg',
                                height: 230.0, fit: BoxFit.fill, scale: 2.0)
                            : Image.file(
                                imgPath,
                                scale: 0.2,
                                height: 230.0,
                                fit: BoxFit.fill,
                              ),
                        SizedBox(height: 27.0),
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
                        itemContainer(signals)
                      ]),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 2.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(colorClass.youtubeBlue),
                          textStyle: MaterialStateProperty.all(
                            TextStyle(color: colorClass.appWhite),
                          ),
                          shape: MaterialStateProperty.all(
                            OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: colorClass.youtubeBlue),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                            ) as OutlinedBorder?,
                          ),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused))
                                return colorClass.youtubeBlue;
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        child: Text("ADD SIGNAL"),
                        onPressed: () {
                          newSignalCallback.onPositive(dialogContex);
                          Navigator.pop(dialogContex);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ]),
          );
        });
  }

  Container itemContainer(NewSignals signals) {
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
                    Text(signals.symbol.toUpperCase(),
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
                        //  width: MediaQuery.of(context).size.width,
                        constraints: BoxConstraints(maxWidth: 100),
                        child: Text(
                          signals.trade_type,
                          style: TextStyle(
                              color: colorClass.appBlack,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400),
                          maxLines: 3,
                        )),
                    SizedBox(height: 27.0),
                    Text(variables.entryPrice2.toUpperCase(),
                        style: TextStyle(
                            color: colorClass.youtubeBlue,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0),
                    signals.entry_price_two == null
                        ? Text('nil')
                        : Text(signals.entry_price_two,
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
                    Text(signals.stop_loss == null ? "Nil" : signals.stop_loss,
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
                    Text(signals.time_frame.toUpperCase(),
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
                    Text(
                        signals.entry_price_one == null
                            ? "Nil"
                            : signals.entry_price_one.toUpperCase(),
                        style: TextStyle(
                            color: colorClass.appBlack,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400)),
                    SizedBox(height: 27.0),
                    Text(variables.date.toUpperCase(),
                        style: TextStyle(
                            color: colorClass.youtubeBlue,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0),
                    Container(
                        constraints: BoxConstraints(maxWidth: 85),
                        child: Text(
                          new CustomVariables().convertCurrentDateToString(),
                          style: TextStyle(
                              color: colorClass.appBlack,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400),
                          maxLines: 3,
                        )),
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
                            size: 11.0, color: colorClass.appRed),
                        SizedBox(width: 5.0),
                        Text('Inactive',
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
          Divider(
            color: colorClass.appGrey,
            height: 20.0,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}
