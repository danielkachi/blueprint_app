
import 'package:blueprint_app2/Admin/callbacks/new_signal_callback.dart';
import 'package:flutter/material.dart';
import '../../utils.dart';

class PasswordChangeDialog{
  ColorClass colorClass = ColorClass();
  Variables variables = Variables();
  CustomVariables customVariables = CustomVariables();
  DialogCallbacks passwordCallback;
  BuildContext buildContext;
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController currentPasswordController = new TextEditingController();

  PasswordChangeDialog(this.passwordCallback, this.buildContext);

  void showMyDialog(){
    showDialog(// (context: context,builder: (dialogContex){
        context: buildContext,
        builder: (dialogContex) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10.0),

            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container (
                      margin: EdgeInsets.only(bottom: 10.0),
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(dialogContex);
                        },
                        child: Icon(
                          Icons.clear, color: colorClass.youtubeBlue, size: 24.0,
                        ),
                      )
                  ),
                  Text("Update Password", style: TextStyle(color: colorClass.youtubeBlue, fontSize: 20.0,  fontWeight: FontWeight.w600, fontFamily: 'Avenir'),),
                  SizedBox(height: 10.0,),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        customVariables.plainText('Current Password', colorClass.appBlack),
                        SizedBox(width: 30.0,),
                        Expanded(
                          child: customVariables.passwordForm(currentPasswordController),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        customVariables.plainText('New password',colorClass.appBlack),
                        SizedBox(width: 30.0,),
                        Expanded(
                          child: customVariables.passwordForm(passwordController),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        customVariables.plainText('Confirm password',colorClass.appBlack),
                        SizedBox(width: 30.0,),
                        Expanded(
                          child: customVariables.passwordForm(confirmPasswordController),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0,),

                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(colorClass.youtubeBlue),
                              textStyle: MaterialStateProperty.all(TextStyle(color: colorClass.appWhite),
                              ),
                              shape: MaterialStateProperty.all(OutlineInputBorder(
                                  borderSide:  BorderSide(color: colorClass.youtubeBlue),
                                  borderRadius: BorderRadius.all(Radius.circular(4.0),
                                  ),) as OutlinedBorder?,),
                              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.focused))
                                    return colorClass.youtubeBlue;
                                  return null; // Defer to the widget's default.
                                },
                              ),
                            ),
                            // focusColor: colorClass.youtubeBlue,
                            child: Text("SAVE CHANGES"),
                            onPressed: () {
                              if(passwordController.text.isEmpty){
                                passwordCallback.onNegative('Invalid password data');
                                Navigator.pop(dialogContex);
                                return;
                              }
                              if(confirmPasswordController.text !=  passwordController.text){
                                passwordCallback.onNegative('passwords do not match');
                                Navigator.pop(dialogContex);
                                return;
                              }
                              passwordCallback.onPasswordChanged(dialogContex, currentPasswordController.text, passwordController.text);
                              Navigator.pop(dialogContex);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ]
            ),

          );
        }
    );
  }
}