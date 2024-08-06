
import 'package:blueprint_app2/utils.dart';
import 'package:flutter/material.dart';

class ProfilePageScreen {
  ColorClass colorClass = ColorClass();
  Variables variables = Variables();
  CustomVariables customVariables = CustomVariables();
  String? phone;
  bool isEditing = false;


  Container profileContainer(String username, String refCode, String phoneNumber, String email, BuildContext context, String? image){

    phone = phoneNumber;
    return Container(
      color:  colorClass.appBlack,
        child: Column(
          children: <Widget>[
            Container(
              color: colorClass.appBlue,
              padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
              child: Column(
                children: [
                  Center(
                      child: image == null  ? CircleAvatar(
                          backgroundImage: AssetImage('assets/user_ic.png'),
                          radius: 45.0
                      ) : CircleAvatar(
                          backgroundImage: NetworkImage(variables.userImageLink+image,  scale: 2 ),
                          radius: 45.0
                      ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                    child: customVariables.plainText('Personal Info', Colors.white70),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                    child: customVariables.plainText('Username', Colors.white30),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                      child: customVariables.plainText(username, Colors.white),
                  ),

                  SizedBox(height: 30.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                    child:Row(
                      children: <Widget>[
                        customVariables.plainText('Ref Code:', Colors.white),
                        SizedBox(width: 20.0),
                        customVariables.plainText(refCode, Colors.white)
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                    child: customVariables.plainText('Contact Information', Colors.white30),
                  ),

                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                    child: customVariables.plainText(phoneNumber, Colors.white),
                  ),

                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                    child: customVariables.plainText('Email', Colors.white30),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0),
                    child: customVariables.plainText(email, Colors.white),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            )
          ],
        ),

    );
  }


  TextFormField passwordForm(TextEditingController controller){
    return TextFormField(
      controller: controller,
      cursorColor: Colors.white,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      style: TextStyle(
          fontFamily: 'Avenir',
          fontWeight: FontWeight.normal,
          color: Colors.white),
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(
            fontFamily: 'Avenir',
            fontWeight: FontWeight.normal,
            color: Colors.white70),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white70)
        ),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
      ),
    );
  }
  TextFormField phoneForm(TextEditingController controller){
    return TextFormField(
      controller: controller,
      cursorColor: Colors.white,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      style: TextStyle(
          fontFamily: 'Avenir',
          fontWeight: FontWeight.normal,
          color: Colors.white),
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(
            fontFamily: 'Avenir',
            fontWeight: FontWeight.normal,
            color: Colors.white70),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white70)
        ),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
      ),
    );
  }
}

