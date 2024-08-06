
import 'package:flutter/cupertino.dart';

abstract class DialogCallbacks {
  void onPositive(BuildContext context);
  void onNegative(String message);
 void onPasswordChanged(BuildContext context, String currentPassword, String newPassword);
}