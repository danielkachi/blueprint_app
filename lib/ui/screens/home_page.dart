import 'dart:io';

import 'package:blueprint_app2/custom_icons/blue_print_calendar_icons.dart';
import 'package:blueprint_app2/custom_icons/blueprint_trade_icons.dart';
import 'package:blueprint_app2/custom_icons/my_flutter_app_icons.dart';
import 'package:blueprint_app2/model/FirebaseUserModel.dart';
import 'package:blueprint_app2/model/signal/signal_data.dart';
import 'package:blueprint_app2/model/user/user_profile.dart';
import 'package:blueprint_app2/services/blueprint_api_service.dart';
import 'package:blueprint_app2/services/navigation_service.dart';
import 'package:blueprint_app2/services/shared_pref.dart';
import 'package:blueprint_app2/ui/navigation_screens/feedback_screen.dart';
import 'package:blueprint_app2/ui/navigation_screens/profile_screen.dart';
import 'package:blueprint_app2/ui/navigation_screens/trade_history.dart';
import 'package:blueprint_app2/ui/navigation_screens/trade_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service_locator.dart';
import '../../utils.dart';

class HomePage extends StatefulWidget {
  static _HomePageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HomePageState>();

  const HomePage({Key? key, this.token, this.password}) : super(key: key);
  final String? token;
  final String? password;
  @override
  State<StatefulWidget> createState() {
    WidgetsFlutterBinding.ensureInitialized();
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  static SharedPref sharedPref = SharedPref();
  ApiService _service = ApiService();
  Variables variables = Variables();
  static UserProfile? userProfile;
  static String? userToken;
  static bool hasNotifications = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? savedPassword;

  @override
  Future<void> initState() async {
    // searchController.dispose();
    super.initState();
    userToken = widget.token;
    if (widget.password != null) {
      savedPassword = widget.password;
      print("Widget pass =" + savedPassword!);
    } else {
      getSavedpassword();
    }
    checkNotification();
  }

  checkNotification() async {
    var response = await _service.getNotifications(widget.token!);
    notificationCount = response.length.toString();
    hasNotifications = true;
  }

  getSavedpassword() async {
    final prefs = await SharedPreferences.getInstance();
    savedPassword = prefs.getString(variables.appPassword);
    print("shared pref pass =" + savedPassword!);
  }

  static TradePage tpage = new TradePage();
  static TradeHistory history = new TradeHistory();
  static FeedBackPage feedBackPage = new FeedBackPage();
  DateTime? currentBackPressTime;
  static ProfilePageScreen profilePage = new ProfilePageScreen();
  static ColorClass colorClass = ColorClass();
  int currentItemIndex = 0;
  String dropdownValue = 'FILTER BY DATE';
  File? image;
  String? userMobile;
  bool updateProfile = false;
  bool editPassword = false;

  TextEditingController searchController = TextEditingController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isSendingFeedback = false;
  static String? notificationCount;
  List<Signals>? allSignals;
  List<Signals> filteredList = [];
  String filter = "";

  static final appBars = [
    tradeAppBar(),
    historyAppBar(),
    feeBackAppBar(),
    profileAppBar()
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBars[currentItemIndex],
      backgroundColor: Colors.black,
      body: WillPopScope(child: mainAppDisplay(), onWillPop: onWillPop),
      //_buildBody(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentItemIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        iconSize: 30.0,
        unselectedFontSize: 10.0,
        selectedFontSize: 13.0,
        unselectedItemColor: colorClass.appGrey,
        selectedItemColor: colorClass.appBlue,
        backgroundColor: colorClass.appBlack,
        items: [
          BottomNavigationBarItem(
            icon: Icon(BlueprintTrade.trade, size: 25),
            label: variables.trade,
          ),
          BottomNavigationBarItem(
            icon: Icon(BluePrintCalendar.calendar__1_, size: 25),
            label: variables.tradeHistory,
          ),
          BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.feedback, size: 25),
            label: variables.feedback,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 25,
            ),
            label: variables.profile,
          ),
        ],
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      showMessage("Press again to exit app");
      // Fluttertoast.showToast(msg: exit_warning);
      return Future.value(false);
    }
    return Future.value(true);
  }

  FutureBuilder mainAppDisplay() {
    return FutureBuilder(
      future: _service.getUserProfile(widget.token!),
      builder: (context, profileSnapshot) {
        switch (profileSnapshot.connectionState) {
          case ConnectionState.none:
            return Container();
            break;
          case ConnectionState.active:
            return Container();
            break;
          case ConnectionState.done:
            if (profileSnapshot.data != null) {
              Profile profileResponse = profileSnapshot.data;
              userProfile = profileResponse.profile;
              userMobile = userProfile?.phone_number;
              setUpUserFirebaseData(userProfile!, context);
              final tabs = [
                tpage.pageContainer(profileResponse, userToken!, context),
                history.historyContainer(
                    profileResponse, context, widget.token!),
                feedBackPage.feedbackContainer(context, widget.token!),
                profilePage.profileContainer(
                  userProfile!.username!,
                  userProfile!.referral_code!,
                  userMobile!,
                  userProfile!.email!,
                  context,
                  userProfile!.photo!,
                ),
              ];

              return tabs[currentItemIndex];
            } else {
              return Container(
                  child: Center(
                child: Text(
                  profileSnapshot.error.toString(),
                  style: TextStyle(
                      color: colorClass.appWhite,
                      fontSize: 15.0,
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.normal),
                ),
              ));
            }
            break;
          case ConnectionState.waiting:
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
        }
        return Container();
      },
    );
  }

  void showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    ));
  }

  void changeState(int index) {
    setState(() {
      currentItemIndex = index;
    });
  }

  void numberCountState(int feeebackLength, int messageTextLength) {
    setState(() {
      feeebackLength = messageTextLength;
      if (feeebackLength > 900) {
        showMessage("Maximum number of text exceeded");
      }
    });
  }

  void changePasswordMode() async {
    setState(() {
      editPassword = !editPassword;
    });
  }

  void updatePasswordToServer() async {
    setState(() {
      editPassword = !editPassword;
    });
  }

  void performSearch() {
    if (searchController.text.isEmpty) {
      setState(() {
        filter = "";
        filteredList = allSignals!;
      });
    } else {
      setState(() {
        filter = searchController.text;
      });
    }
  }

  void switchFeedbackSending() {
    setState(() {
      isSendingFeedback = !isSendingFeedback;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      currentItemIndex = index;
    });
  }

  static AppBar tradeAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: colorClass.appBlue,
      leading: GestureDetector(
        onTap: () async {
          sharedPref.clearAll();
          locator<NavigationService>().navigateTo(new Variables().login);
        },
        child: Icon(
          Icons.power_settings_new,
          color: colorClass.appWhite,
        ),
      ),
      actions: <Widget>[
        GestureDetector(
          child: Row(
            children: <Widget>[
              hasNotifications
                  ? Image.asset(
                      'assets/notif.png',
                      height: 24.0,
                      width: 24.0,
                    )
                  : Image.asset(
                      'assets/notif.png',
                      height: 24.0,
                      width: 24.0,
                    ),
              SizedBox(width: 10.0)
            ],
          ),
          onTap: () {
            locator<NavigationService>()
                .navigateTo(new Variables().notification);
          },
        ),
      ],
    );
  }

  static AppBar historyAppBar() {
    return AppBar(
      backgroundColor: colorClass.appBlue,
      elevation: 0,
      title: Text('TRADE HISTORY',
          style: TextStyle(
              fontFamily: 'Avenir',
              fontWeight: FontWeight.bold,
              color: colorClass.appWhite,
              fontSize: 15.0)),
      centerTitle: true,
    );
  }

  static feeBackAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: colorClass.appBlue,
      title: Text('FEEDBACKS',
          style: TextStyle(
              color: colorClass.appWhite,
              fontSize: 15.0,
              fontFamily: 'Avenir',
              fontWeight: FontWeight.bold)),
      centerTitle: true,
    );
  }

  static profileAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: colorClass.appBlue,
      title: Text('PROFILE',
          style: TextStyle(
              color: colorClass.appWhite,
              fontSize: 15.0,
              fontFamily: 'Avenir',
              fontWeight: FontWeight.bold)),
      centerTitle: true,
      actions: <Widget>[
        GestureDetector(
          child: Row(
            children: <Widget>[
              Icon(
                Icons.border_color,
                color: colorClass.appWhite,
                size: 20.0,
              ),
              SizedBox(width: 10.0)
            ],
          ),
          onTap: () {
            locator<NavigationService>()
                .navigateTo(new Variables().editProfile);
          },
        ),
      ],
    );
  }

  void setUpUserFirebaseData(UserProfile appUser, BuildContext ctx) async {
    User user = auth.currentUser!;
    print(appUser.email);
    print('User is signed in!');
    updateFirebaseData();
  }

  updateFirebaseData() async {
    String? token = await FirebaseMessaging.instance.getToken();
    String useriId = auth.currentUser!.uid;
    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child("Users");
    FirebaseUserModel userModel = FirebaseUserModel(token!, useriId);
    userRef.child(useriId).set(userModel.toJson());
  }
}
