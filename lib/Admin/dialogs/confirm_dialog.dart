import 'package:blueprint_app2/Admin/callbacks/new_signal_callback.dart';
import 'package:blueprint_app2/services/shared_pref.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';

class ConfirmDialog {
  ColorClass colorClass = ColorClass();
  Variables variables = Variables();
  DialogCallbacks deleteSignalCallback;
  BuildContext buildContext;

  ConfirmDialog(this.deleteSignalCallback, this.buildContext);

  void showMyDialog(BuildContext context) async {
    SharedPref sharedPref = SharedPref();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Delete Signal',
              textScaleFactor: 1,
            ),
            content: SingleChildScrollView(
              // won't be scrollable
              child: Text(
                  'Are you sure you want to Delete this Signal, this action cannot be undone',
                  textScaleFactor: 1),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text('No'),
                  onPressed: () {
                    deleteSignalCallback.onNegative("");
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    deleteSignalCallback.onPositive(context);
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }
}
