import 'dart:convert';
import 'dart:io';

import 'package:blueprint_app2/Admin/callbacks/new_signal_callback.dart';
import 'package:blueprint_app2/model/authentication/sign_in_response.dart';
import 'package:blueprint_app2/model/user/user_profile.dart';
import 'package:blueprint_app2/services/blueprint_api_service.dart';
import 'package:blueprint_app2/services/shared_pref.dart';
import 'package:blueprint_app2/ui/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils.dart';
import '../dialogs_ui/password_change.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.token}) : super(key: key);

  final String? token;
  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfilePage>
    implements DialogCallbacks {
  ApiService _service = ApiService();
  Variables variables = Variables();
  ColorClass colorClass = ColorClass();
  CustomVariables customVariables = CustomVariables();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  File? image;
  final String imagePath = "";
  bool updating = false;
  bool isEditing = false;
  String? userPhone;

  String? mainToken;

  @override
  void initState() {
    super.initState();
    if (widget.token == null) {
      fetchToken();
    } else {
      mainToken = widget.token;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorClass.appBlack,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: colorClass.appBlue,
        elevation: 0,
        title: Text('EDIT PROFILE',
            style: TextStyle(
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
                color: colorClass.appWhite,
                fontSize: 15.0)),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            child: Row(
              children: <Widget>[
                customVariables.plainText('SAVE', colorClass.appWhite),
                SizedBox(width: 10.0)
              ],
            ),
            onTap: () async {
              if (phoneController.text.isEmpty) {
                showMessage("Enter your phone number");
                return;
              }
              if (phoneController.text == userPhone && image == null) {
                showMessage("There were no changes made");
                return;
              }

              try {
                final result = await InternetAddress.lookup('example.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  updateProfile(context);
                }
              } on SocketException catch (_) {
                showMessage("Check internet connections");
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder(
              future: _service.getUserProfile(mainToken!),
              builder: (BuildContext buildcontext, profileSnapshot) {
                switch (profileSnapshot.connectionState) {
                  case ConnectionState.none:
                    return customVariables.loadingContainer(
                        '', colorClass.appWhite, false);
                    break;
                  case ConnectionState.waiting:
                    return customVariables.loadingContainer(
                        '', colorClass.appWhite, false);
                    break;
                  case ConnectionState.active:
                    return customVariables.loadingContainer(
                        '', colorClass.appWhite, false);
                    break;
                  case ConnectionState.done:
                    if (profileSnapshot.hasError) {
                      return networkErrorContainer(context);
                    } else {
                      if (profileSnapshot.data == null) {
                        return networkErrorContainer(context);
                      } else {
                        Profile? profileResponse =
                            profileSnapshot.data as Profile?;
                        return profileContainer(
                            profileResponse!.profile!, context);
                      }
                    }
                    break;
                }
                return Container();
              }),
          updating
              ? customVariables.loadingContainer(
                  "Updating", colorClass.appWhite, true)
              : Container(),
        ],
      ),
    );
  }

  fetchToken() async {
    String token;
    Map<String, dynamic> val = await SharedPref().read(new Variables().users);
    SignInResponse signInResponse = SignInResponse.fromJson(val);
    token = signInResponse.bearer_token!;
    mainToken = token;
  }

  Container profileContainer(UserProfile profile, BuildContext ctx) {
    return Container(
      color: colorClass.appBlack,
      child: Column(
        children: <Widget>[
          Container(
            color: colorClass.appBlue,
            padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
            child: Column(
              children: [
                Center(
                  child: image == null
                      ? CircleAvatar(
                          backgroundImage: profile.photo == null
                              ? AssetImage('assets/user_ic.png')
                                  as ImageProvider<Object>?
                              : NetworkImage(
                                  variables.userImageLink + profile.photo!,
                                  scale: 2),
                          radius: 50.0)
                      : CircleAvatar(
                          backgroundImage: FileImage(image!, scale: 2.0),
                          radius: 50.0),
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                    onTap: () async {
                      cameraConnect(ctx);
                    },
                    child: Text('UPLOAD PHOTO',
                        style: TextStyle(
                            color: colorClass.appWhite,
                            fontSize: 13.0,
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.w400)))
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                  child:
                      customVariables.plainText('Phone number', Colors.white30),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Phone number",
                      hintStyle: TextStyle(
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.normal,
                          color: Colors.white70),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70)),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70)),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                  alignment: Alignment.topLeft,
                  child: customVariables.plainText(
                      'Password Settings', Colors.white30),
                ),
                SizedBox(height: 20.0),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        PasswordChangeDialog(this, scaffoldKey.currentContext!)
                            .showMyDialog();
                      },
                      child: customVariables.plainText(
                          'Reset Password', Colors.white70),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  cameraConnect(BuildContext context) async {
    print('Picker is Called');
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        image = File(imageFile.path);
        isEditing = true;
      });
    }
  }

  void updateProfile(BuildContext ctx) async {
    setState(() {
      updating = true;
    });
    var response =
        await _service.updateProfile(image!, phoneController.text, mainToken!);
    //Map<String, dynamic> convertedApiResponse = jsonDecode(jsonEncode(apiResponse.data));
    String data = response.data["message"];
    setState(() {
      updating = false;
      showMessage(data);
    });

    Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => HomePage(
                  token: mainToken,
                )),
        (Route<dynamic> route) => false);
  }

  Container networkErrorContainer(BuildContext context) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Something went wrong",
              style: TextStyle(
                  color: colorClass.appWhite,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Avenir'),
            ),
            GestureDetector(
              onTap: () {},
              child: Center(
                child: Text(
                  'Try again',
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

  @override
  void onNegative(String message) {
    showMessage(message);
  }

  @override
  void onPositive(BuildContext context) {
    // TODO: implement onNegative
  }

  @override
  void onPasswordChanged(
      BuildContext context, String currentPassword, String newPassword) async {
    setState(() {
      updating = true;
    });
    var response =
        await _service.updatePassword(currentPassword, newPassword, mainToken!);
    setState(() {
      updating = false;
    });
    Map<String, dynamic> convertedApiResponse =
        jsonDecode(jsonEncode(response.data));
    String data = convertedApiResponse["message"];
    showMessage(data);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => HomePage(
                  token: mainToken,
                )),
        (Route<dynamic> route) => false);
  }

  showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(message),
      duration: Duration(seconds: 4),
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    ));
  }
}
