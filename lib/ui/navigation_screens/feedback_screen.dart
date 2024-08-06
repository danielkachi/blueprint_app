import 'package:blueprint_app2/model/api_response.dart';
import 'package:blueprint_app2/model/server_response.dart';
import 'package:blueprint_app2/services/blueprint_api_service.dart';
import 'package:blueprint_app2/ui/screens/home_page.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:flutter/material.dart';

class FeedBackPage {
  ColorClass colorClass = ColorClass();
  TextEditingController? subjectController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();
  ApiService apiService = ApiService();
  bool? isLoading;
  int feedbackLength = 0;

  Container feedbackContainer(BuildContext context, String token) {
    return Container(
      padding: EdgeInsets.all(20.0),
      color: colorClass.appBlack,
      child: ListView(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 20.0),
              height: 76.0,
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: colorClass.appGrey,
                        style: BorderStyle.solid,
                        width: 0.5),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        maxLines: 2,
                        controller: subjectController,
                        style: TextStyle(
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
                            color: colorClass.appWhite),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: colorClass.appGrey)),
                          hintText: 'Subject',
                          hintStyle: TextStyle(
                              color: colorClass.appGrey,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Avenir',
                              fontSize: 15.0),
                        ),
                      ),
                    ),
//                    Icon(Icons.expand_more,
//                        color: colorClass.appGrey,
//                        size: 13.0),
                  ],
                ),
              )),
          SizedBox(height: 20.0),
          Container(
              height: 219.0,
              margin: EdgeInsets.only(top: 30.0),
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: colorClass.appGrey,
                          style: BorderStyle.solid,
                          width: 0.5),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(3.0)),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: messageController,
                          keyboardType: TextInputType.text,
                          maxLines: 9,
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: colorClass.appWhite),
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: colorClass.appGrey)),
                            hintText: 'Type your message here',
                            hintStyle: TextStyle(
                                color: colorClass.appGrey,
                                fontWeight: FontWeight.w300,
                                fontSize: 15.0),
                          ),
                        ),
                      ),
                    ],
                  ))),
          SizedBox(height: 15.0),
          HomePage.of(context)!.isSendingFeedback
              ? CircularProgressIndicator()
              : GestureDetector(
                  onTap: () {
                    // Perform the required  filter
                    sendFeedback(context, token);
                  },
                  child: Container(
                    height: 50.0,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.appBlue,
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: colorClass.appBlue,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: Center(
                          child: Text(
                            'SEND FEEDBACK',
                            style: TextStyle(
                                color: colorClass.appWhite,
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                        )),
                  )),
        ],
      ),
    );
  }

  sendFeedback(BuildContext context, String token) async {
    if (subjectController!.text.isEmpty) {
      HomePage.of(context)!
          .showMessage("Enter a Title/Subject for this feedback");
      return;
    }

    if (messageController.text.isEmpty) {
      HomePage.of(context)!.showMessage("Enter a message body");
      return;
    }

    if (messageController.text.length > 900) {
      HomePage.of(context)!
          .showMessage("Message should not exceed 900 characters");
      return;
    }

    HomePage.of(context)!.switchFeedbackSending();
    ApiResponse response = await apiService.sendUserFeedBack(
        token, subjectController!.text, messageController.text);
    if (response.status!) {
      HomePage.of(context)!.switchFeedbackSending();
      ServerResponse? serverResponse = ServerResponse.fromJson(response.data);
      if (serverResponse.message!.isEmpty) {
        subjectController!.text = "";
        messageController.text = "";
        HomePage.of(context)!.showMessage(serverResponse.message!);
      }
    }
    }
}
