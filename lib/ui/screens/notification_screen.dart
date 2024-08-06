import 'package:blueprint_app2/model/authentication/sign_in_response.dart';
import 'package:blueprint_app2/model/notification/notification_response.dart';
import 'package:blueprint_app2/services/blueprint_api_service.dart';
import 'package:blueprint_app2/services/shared_pref.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key, this.token}) : super(key: key);

  final String? token;
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  ApiService _service = ApiService();
  ColorClass colorClass = ColorClass();
  String? token;
  bool _isLoading = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.token == null) {
      fetchToken();
    } else {
      token = widget.token;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorClass.appBlack,
      appBar: AppBar(
        backgroundColor: colorClass.appBlue,
        title: Text(
          'NOTIFICATION',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : token == null
              ? Container(
                  child: Center(
                    child: Text('Connection timed out'),
                  ),
                )
              : FutureBuilder(
                  future: _service.getNotifications(token!),
                  builder: (context, dataSnapshot) {
                    switch (dataSnapshot.connectionState) {
                      case ConnectionState.waiting:
                        _isLoading = true;
                        return Container(
                          child: Center(
                            child: Text(
                              "Please wait...",
                              style: TextStyle(
                                  color: colorClass.appWhite,
                                  fontSize: 18.0,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                        break;
                      case ConnectionState.done:
                        _isLoading = false;
                        if (dataSnapshot.hasError) {
                          return Center(
                            child: Text(
                              'Operation timed out',
                              style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.normal,
                                  color: colorClass.appGrey),
                            ),
                          );
                        } else {
                          if (dataSnapshot.data != null) {
                            List<FeedbackResponse>? messages =
                                dataSnapshot.data as List<FeedbackResponse>?;
                            if (messages != null) {
                              return allNotifications(messages);
                            } else {
                              return Center(
                                child: Text(
                                  'No Notification',
                                  style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontWeight: FontWeight.normal,
                                      color: colorClass.appGrey),
                                ),
                              );
                            }
                          }
                        }
                        return Container(); // Add this return statement
                      case ConnectionState.none:
                        // TODO: Handle this case.
                        break;
                      case ConnectionState.active:
                        // TODO: Handle this case.
                        break;
                    }
                    return Container(); // Add this return statement
                  },
                ),
    );
  }

  ListView allNotifications(List<FeedbackResponse> notifications) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return itemCard(notifications[index]);
      },
    );
  }

  fetchToken() async {
    String mainToken;
    Map<String, dynamic> val = await SharedPref().read(new Variables().users);
    SignInResponse signInResponse = SignInResponse.fromJson(val);
    mainToken = signInResponse.bearer_token!;
    setState(() {
      token = mainToken;
    });
  }

  void copyValue(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    _showToast("Copied ");
  }

  void _showToast(String label) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: Text(label),
      duration: Duration(seconds: 4),
    ));
  }

  Card itemCard(FeedbackResponse notificationResponse) {
    return new Card(
      color: colorClass.appBlack,
      elevation: 0,
      child: ListTile(
          contentPadding: EdgeInsets.all(5.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                notificationResponse.title!,
                style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: colorClass.appWhite),
              ),
              GestureDetector(
                onTap: () {
                  copyValue(context, notificationResponse.text!);
                },
                child: Icon(
                  Icons.content_copy,
                  color: colorClass.appGrey,
                  size: 18.0,
                ),
              )
            ],
          ),
          subtitle: Text(
            notificationResponse.text!,
            style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.w300,
                color: colorClass.appWhite),
          )),
    );
  }
}
