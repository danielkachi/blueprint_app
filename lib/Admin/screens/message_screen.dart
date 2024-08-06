import 'package:blueprint_app2/model/FirebaseNotificationModel.dart';
import 'package:blueprint_app2/model/notification/notification_response.dart';
import 'package:blueprint_app2/services/blueprint_admin_api_service.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageScreens extends StatefulWidget {
  static _MessageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MessageState>();

  const MessageScreens({Key? key, this.token, this.notificationResponse})
      : super(key: key);
  final String? token;
  final NotificationResponse? notificationResponse;

  @override
  State<StatefulWidget> createState() {
    WidgetsFlutterBinding.ensureInitialized();
    return _MessageState();
  }
}

class _MessageState extends State<MessageScreens> {
  AdminApiService apiService = AdminApiService();
  static ColorClass colorClass = ColorClass();
  Variables variables = Variables();
  CustomVariables customVariables = CustomVariables();
  List<FeedbackResponse>? apiFeedbackList;
  List<NotificationResponse>? apimessageList;
  TextEditingController searchController = TextEditingController();
  TextEditingController receiverController = TextEditingController();
  TextEditingController subjectontroller = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List<NotificationResponse> _filteredList = [];
  List<FeedbackResponse> _feedbackfilteredList = [];
  String filter = "";

  bool inboxSelected = false;
  bool outboxSelected = true;
  bool inEditMode = false;
  bool isSendingMessage = false;
  bool viewMessageMode = false;
  NotificationResponse? messageToEdit;

  @override
  void initState() {
    super.initState();
    messageToEdit = widget.notificationResponse;
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        if (inboxSelected) {
          setState(() {
            filter = "";
            _feedbackfilteredList = apiFeedbackList!;
          });
        } else {
          setState(() {
            filter = "";
            _filteredList = apimessageList!;
          });
        }
      } else {
        setState(() {
          filter = searchController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: colorClass.appWhite,
        body: Container(
            padding: EdgeInsets.all(10.0),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Text('Messaging',
                        style: TextStyle(
                            color: colorClass.youtubeBlue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          inEditMode = !inEditMode;
                        });
                      },
                      child: Container(
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
                          child: Center(
                            child: inEditMode
                                ? Text('Cancel',
                                    style: TextStyle(
                                        color: colorClass.appWhite,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Avenir'))
                                : Text('Compose',
                                    style: TextStyle(
                                        color: colorClass.appWhite,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Avenir')),
                          )),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  outboxSelected = true;
                                  inboxSelected = false;
                                });
                              },
                              child: Container(
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Sent',
                                          style: TextStyle(
                                              color: colorClass.youtubeBlue,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold)),
                                      FutureBuilder(
                                        future:
                                            apiService.getNotificationHistory(
                                                widget.token!),
                                        builder: (context, feedbackSnapshot) {
                                          switch (feedbackSnapshot
                                              .connectionState) {
                                            case ConnectionState.waiting:
                                              return Text('0',
                                                  style: TextStyle(
                                                      color:
                                                          colorClass.appBlack,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold));
                                              break;
                                            case ConnectionState.active:
                                              return Text('0',
                                                  style: TextStyle(
                                                      color:
                                                          colorClass.appBlack,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold));
                                              break;
                                            case ConnectionState.none:
                                              return Text('0',
                                                  style: TextStyle(
                                                      color:
                                                          colorClass.appBlack,
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold));
                                              break;
                                            case ConnectionState.done:
                                              if (feedbackSnapshot.data !=
                                                  null) {
                                                apimessageList = feedbackSnapshot
                                                        .data
                                                    as List<
                                                        NotificationResponse>?;
                                                return Text(
                                                    apimessageList!.length
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            colorClass.appBlack,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold));
                                              } else {
                                                return Text('0',
                                                    style: TextStyle(
                                                        color:
                                                            colorClass.appBlack,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold));
                                              }
                                              break;
                                          }
                                          return Text('0',
                                              style: TextStyle(
                                                  color: colorClass.appBlack,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold));
                                        },
                                      )
                                    ]),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    outboxSelected = false;
                                    inboxSelected = true;
                                  });
                                },
                                child: Container(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Inbox',
                                            style: TextStyle(
                                                color: colorClass.youtubeBlue,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold)),
                                        FutureBuilder(
                                          future: apiService.getFeedbackHistory(
                                              widget.token!),
                                          builder: (context, feedbackSnapshot) {
                                            switch (feedbackSnapshot
                                                .connectionState) {
                                              case ConnectionState.waiting:
                                                return Text('0',
                                                    style: TextStyle(
                                                        color:
                                                            colorClass.appBlack,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold));
                                                break;
                                              case ConnectionState.active:
                                                return Text('0',
                                                    style: TextStyle(
                                                        color:
                                                            colorClass.appBlack,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold));
                                                break;
                                              case ConnectionState.none:
                                                return Text('0',
                                                    style: TextStyle(
                                                        color:
                                                            colorClass.appBlack,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.bold));
                                                break;
                                              case ConnectionState.done:
                                                if (feedbackSnapshot.data !=
                                                    null) {
                                                  apiFeedbackList =
                                                      feedbackSnapshot.data
                                                          as List<
                                                              FeedbackResponse>?;
                                                  return Text(
                                                      apiFeedbackList!.length
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: colorClass
                                                              .appBlack,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold));
                                                } else {
                                                  return Text('0',
                                                      style: TextStyle(
                                                          color: colorClass
                                                              .appBlack,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold));
                                                }
                                                break;
                                            }
                                            return Text('0',
                                                style: TextStyle(
                                                    color: colorClass.appBlack,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.bold));
                                          },
                                        )
                                      ]),
                                )),
                            SizedBox(height: 25.0),
                            inEditMode
                                ? Container()
                                : Container(
                                    child: Row(
                                      children: [
                                        Icon(Icons.search,
                                            color: colorClass.appGrey,
                                            size: 26.0),
                                        SizedBox(width: 20.0),
                                        Expanded(
                                            child: TextFormField(
                                          controller: searchController,
                                          style: TextStyle(
                                              color: colorClass.appBlack),
                                          decoration: InputDecoration(
                                            labelText:
                                                "Search Message or Name...",
                                            labelStyle: TextStyle(
                                                fontFamily: 'Avenir',
                                                fontWeight: FontWeight.normal,
                                                color: colorClass.appGrey),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                          ],
                        )),
                    inEditMode
                        ? editContainer()
                        : Container(
//                         height: 450.0,
                            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                            child: inboxSelected
                                ? FutureBuilder(
                                    future: apiService
                                        .getFeedbackHistory(widget.token!),
                                    builder: (context, feedbackSnapshot) {
                                      switch (
                                          feedbackSnapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return customVariables
                                              .lightLoadingContainer(
                                                  "", colorClass.appGrey, true);
                                          break;
                                        case ConnectionState.active:
                                          return customVariables
                                              .lightLoadingContainer(
                                                  "", colorClass.appGrey, true);
                                          break;
                                        case ConnectionState.none:
                                          return customVariables
                                              .lightLoadingContainer(
                                                  "", colorClass.appGrey, true);
                                          break;
                                        case ConnectionState.done:
                                          if (feedbackSnapshot.data != null) {
                                            apiFeedbackList =
                                                feedbackSnapshot.data
                                                    as List<FeedbackResponse>?;
                                            if ((filter.isNotEmpty)) {
                                              List<FeedbackResponse>? tmpList;
                                              for (int i = 0;
                                                  i <
                                                      _feedbackfilteredList
                                                          .length;
                                                  i++) {
                                                if (_feedbackfilteredList[i]
                                                        .username!
                                                        .toLowerCase()
                                                        .contains(filter
                                                            .toLowerCase()) ||
                                                    _feedbackfilteredList[i]
                                                        .message!
                                                        .toLowerCase()
                                                        .contains(filter
                                                            .toLowerCase())) {
                                                  tmpList!.add(
                                                      _feedbackfilteredList[i]);
                                                }
                                              }
                                              _feedbackfilteredList = tmpList!;
                                            } else {
                                              _feedbackfilteredList =
                                                  apiFeedbackList!;
                                            }
                                            return dataList(
                                                apiFeedbackList!, []);
                                          } else {
                                            return errorView();
                                          }
                                          break;
                                      }
                                      return errorView();
                                    },
                                  )
                                : FutureBuilder(
                                    future: apiService
                                        .getNotificationHistory(widget.token!),
                                    builder: (context, feedbackSnapshot) {
                                      switch (
                                          feedbackSnapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return customVariables
                                              .lightLoadingContainer(
                                                  "", colorClass.appGrey, true);
                                          break;
                                        case ConnectionState.active:
                                          return customVariables
                                              .lightLoadingContainer(
                                                  "", colorClass.appGrey, true);
                                          break;
                                        case ConnectionState.none:
                                          return customVariables
                                              .lightLoadingContainer(
                                                  "", colorClass.appGrey, true);
                                          break;
                                        case ConnectionState.done:
                                          if (feedbackSnapshot.data != null) {
                                            apimessageList = feedbackSnapshot
                                                    .data
                                                as List<NotificationResponse>?;
                                            if ((filter.isNotEmpty)) {
                                              List<NotificationResponse>?
                                                  tmpList;
                                              for (int i = 0;
                                                  i < _filteredList.length;
                                                  i++) {
                                                if (_filteredList[i]
                                                        .title!
                                                        .toLowerCase()
                                                        .contains(filter
                                                            .toLowerCase()) ||
                                                    _filteredList[i]
                                                        .text!
                                                        .toLowerCase()
                                                        .contains(filter
                                                            .toLowerCase())) {
                                                  tmpList!
                                                      .add(_filteredList[i]);
                                                }
                                              }
                                              _filteredList = tmpList!;
                                            } else {
                                              _filteredList = apimessageList!;
                                            }
                                            return dataList(
                                                [], apimessageList!);
                                          } else {
                                            return errorView();
                                          }
                                          break;
                                      }
                                      return errorView();
                                    },
                                  )),
                  ],
                ),
              ],
            )));
  }

  ListView dataList(
      List<FeedbackResponse>? inbox, List<NotificationResponse> outbox) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: inbox == null ? 0 : _feedbackfilteredList.length,
        itemBuilder: (context, index) {
          return contentBody(NotificationResponse(), inbox?[index]);
        });
  }

  Container contentBody(NotificationResponse body, FeedbackResponse? feedback) {
    return Container(
        child: GestureDetector(
      onTap: () {
        showMyDialog(context, body, feedback!);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              feedback == null
                  ? Text(body.title!,
                      style: TextStyle(
                          color: colorClass.appBlack,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold))
                  : Text(
                      feedback.username! +
                          "  - " +
                          getStringLength(feedback.title!),
                      style: TextStyle(
                          color: colorClass.appBlack,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold)),
              feedback == null
                  ? Text(customVariables.formatedDate(body.created_at!),
                      style: TextStyle(
                          color: colorClass.appGrey,
                          fontSize: 13.0,
                          fontWeight: FontWeight.normal))
                  : Text(customVariables.formatedDate(feedback.created_at!),
                      style: TextStyle(
                          color: colorClass.appGrey,
                          fontSize: 13.0,
                          fontWeight: FontWeight.normal)),
            ],
          ),
          SizedBox(height: 10.0),
          feedback == null
              ? Text(
                  getStringLength(body.text!),
                  style: TextStyle(
                      color: colorClass.appGrey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal),
                  maxLines: 1,
                )
              : Text(getStringLength(feedback.message!),
                  style: TextStyle(
                      color: colorClass.appGrey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal)),
          SizedBox(height: 5.0),
        ],
      ),
    ));
  }

  Container editContainer() {
    if (messageToEdit != null) {
      subjectontroller.text = messageToEdit!.title!;
      messageController.text = messageToEdit!.text!;
    }

    return Container(
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: colorClass.appBlack, width: 0.3),
              borderRadius: BorderRadius.circular(4.0),
              color: colorClass.appWhite,
            ),
            padding: EdgeInsets.only(left: 8.0),
            child: TextFormField(
              controller: subjectontroller,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(color: colorClass.appBlack),
              decoration: InputDecoration(
                labelText: "Subject",
                labelStyle: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: colorClass.appGrey),
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: colorClass.appBlack, width: 0.3),
              borderRadius: BorderRadius.circular(4.0),
              color: colorClass.appWhite,
            ),
            padding: EdgeInsets.only(left: 8.0),
            height: 250.0,
            child: TextFormField(
              controller: messageController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(color: colorClass.appBlack),
              decoration: InputDecoration(
                labelText: "Write something",
                labelStyle: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.normal,
                    color: colorClass.appGrey),
              ),
            ),
          ),
          SizedBox(height: 15.0),
          GestureDetector(
            onTap: () {
              !isSendingMessage ? checkAndSendMessage() : null;
            },
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                border: Border.all(color: colorClass.appBlack, width: 0.3),
                borderRadius: BorderRadius.circular(4.0),
                color: colorClass.youtubeBlue,
              ),
              child: Center(
                child: isSendingMessage
                    ? Text('Sending...',
                        style: TextStyle(
                            color: colorClass.appWhite,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Avenir'))
                    : Text('Send',
                        style: TextStyle(
                            color: colorClass.appWhite,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Avenir')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void prepareToEdit(NotificationResponse notificationResponse) {
    setState(() {
      messageToEdit = notificationResponse;
      inEditMode = true;
    });
  }

  void checkAndSendMessage() async {
    if (messageController.text.isEmpty || subjectontroller.text.isEmpty) {
      showMessage("Can't sent message with empty body or title ");
      return;
    }
    String msg = messageController.text;
    String title = subjectontroller.text;
    sendFirebaseNotification(msg, title);
    setState(() {
      messageToEdit = null;
      isSendingMessage = true;
    });
    var response = await apiService.composeMessage(
        subjectontroller.text, messageController.text, widget.token!, [""]);
    String message = response;
    messageController.clear();
    subjectontroller.clear();
    setState(() {
      inEditMode = !inEditMode;
      isSendingMessage = false;
    });
    showMessage(message);
  }

  sendFirebaseNotification(String message, String title) async {
    DatabaseReference notificationRef =
        FirebaseDatabase.instance.reference().child("Notifications");
    String? messageId = notificationRef.push().key;
    FirebaseNotificationModel notificationModel =
        FirebaseNotificationModel(message, title, messageId!);
    notificationRef.child(messageId).set(notificationModel.toJson());
  }

  String getStringLength(String text) {
    if (text.length > 25) {
      return text.substring(0, 25);
    } else {
      return text;
    }
  }

  Container errorView() {
    return Container(
      child: Center(
        child: Text('No item found',
            style: TextStyle(
                color: colorClass.appGrey,
                fontSize: 15.0,
                fontWeight: FontWeight.bold)),
      ),
    );
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

  void showMyDialog(BuildContext context, NotificationResponse feedback,
      FeedbackResponse? feedbackMessage) async {
    String to = '';
    String mainName;
    if (feedbackMessage == null) {
      to = 'To Everyone';
      mainName = 'Admin';
    } else {
      to = 'To Admin';
      mainName = feedbackMessage.username!;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10.0),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
                        SizedBox(height: 10.0),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              feedbackMessage == null
                                  ? Row(
                                      children: [
                                        feedback.photo == null
                                            ? CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/user_ic.png'),
                                                radius: 20.0)
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    variables.userImageLink +
                                                        feedback.photo!,
                                                    scale: 2),
                                                backgroundColor:
                                                    Colors.transparent,
                                                radius: 20.0),
                                        SizedBox(width: 5.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(mainName,
                                                style: TextStyle(
                                                    color: colorClass.appBlack,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Avenir')),
                                            Text(to,
                                                style: TextStyle(
                                                    color: colorClass.appGrey,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Avenir')),
                                          ],
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        feedbackMessage.photo == null
                                            ? CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/user_ic.png'),
                                                radius: 20.0)
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    variables.userImageLink +
                                                        feedbackMessage.photo!,
                                                    scale: 2),
                                                backgroundColor:
                                                    Colors.transparent,
                                                radius: 20.0),
                                        SizedBox(width: 5.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(mainName,
                                                style: TextStyle(
                                                    color: colorClass.appBlack,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Avenir')),
                                            Text(to,
                                                style: TextStyle(
                                                    color: colorClass.appGrey,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Avenir')),
                                          ],
                                        )
                                      ],
                                    ),
                              feedbackMessage == null
                                  ? Text(
                                      customVariables
                                          .formatedDate(feedback.created_at!),
                                      style: TextStyle(
                                          color: colorClass.appGrey,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Avenir'))
                                  : Text(
                                      customVariables.formatedDate(
                                          feedbackMessage.created_at!),
                                      style: TextStyle(
                                          color: colorClass.appGrey,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Avenir')),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Divider(
                          color: colorClass.appGrey,
                          height: 20.0,
                          thickness: 1.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: colorClass.appBlack, width: 0.3),
                            borderRadius: BorderRadius.circular(4.0),
                            color: colorClass.appWhite,
                          ),
                          padding: EdgeInsets.all(5.0),
                          height: 250.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              feedbackMessage == null
                                  ? Text(feedback.title!,
                                      style: TextStyle(
                                          color: colorClass.appBlack,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold))
                                  : Text(feedbackMessage.title!,
                                      style: TextStyle(
                                          color: colorClass.appBlack,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold)),
                              SizedBox(height: 5.0),
                              Flexible(
                                child: SingleChildScrollView(
                                  child: feedbackMessage == null
                                      ? Text(feedback.text!,
                                          style: TextStyle(
                                              color: colorClass.appBlack,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.normal))
                                      : Text(feedbackMessage.message!,
                                          style: TextStyle(
                                              color: colorClass.appBlack,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.normal)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0),
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
                        child: feedbackMessage != null
                            ? Text("CANCEL")
                            : Text("EDIT"),
                        onPressed: () async {
                          //  Navigator.pop(context);
                          if (feedbackMessage == null) {
                            prepareToEdit(feedback);
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                          }
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
}
