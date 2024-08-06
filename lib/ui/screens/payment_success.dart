import 'package:blueprint_app2/utils.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class Successpage extends StatefulWidget {
  const Successpage({required Key key, this.token}) : super(key: key);
  final String? token;

  @override
  State<StatefulWidget> createState() {
    return _SuccesspageState();
  }
}

class _SuccesspageState extends State<Successpage> {
  ColorClass colorClass = ColorClass();
  Variables variables = new Variables();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.fromLTRB(80.0, 60.0, 80.0, 30.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 100.0),
                height: 130.0,
                width: 130.0,
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(color: Colors.white, width: 2.0),
                    color: Colors.black,
                  ),
                  child: Center(
                      child: Icon(
                    Icons.check,
                    size: 70.0,
                    color: Colors.white,
                  )),
                ),
              ),
              SizedBox(height: 50.0),
              Text(variables.success,
                  style: TextStyle(
                      fontSize: 23.0,
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.normal,
                      color: Colors.white)),
              SizedBox(
                height: 25.0,
              ),
              Text(
                variables.successText,
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 80.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage(
                                token: widget.token!,
                              )),
                      (Route<dynamic> route) => false);
                },
                child: Container(
                  height: 50.0,
                  width: 172.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(23.0),
                    color: colorClass.appBlue,
                    child: Center(
                      child: Text(
                        'CLOSE',
                        style: TextStyle(
                            color: colorClass.appWhite,
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
