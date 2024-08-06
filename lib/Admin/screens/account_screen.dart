import 'package:blueprint_app2/model/user/user_profile.dart';
import 'package:blueprint_app2/services/blueprint_admin_api_service.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key, this.token}) : super(key: key);
  final String? token;
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AdminApiService apiService = AdminApiService();
  static ColorClass colorClass = ColorClass();
  Variables variables = Variables();
  CustomVariables customVariables = CustomVariables();
  TextEditingController searchController = TextEditingController();
  List<UserProfile>? allAccounts;
  List<UserProfile> _filteredList = [];
  String filter = "";

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          filter = "";
          _filteredList = allAccounts!;
        });
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
      backgroundColor: colorClass.appWhite,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            alignment: Alignment.topLeft,
            child: Text('Accounts',
                style: TextStyle(
                    color: colorClass.youtubeBlue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 16.0),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            padding: EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: colorClass.appGrey, width: 0.3),
              borderRadius: BorderRadius.circular(4.0),
              color: colorClass.appWhite,
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: searchController,
                  style: TextStyle(color: colorClass.appBlack),
                  decoration: InputDecoration(
                    labelText: "Search by email address or username",
                    labelStyle: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.normal,
                        color: colorClass.appGrey),
                  ),
                )),
                SizedBox(width: 10.0),
                Icon(
                  Icons.search,
                  color: colorClass.youtubeBlue,
                  size: 25.0,
                ),
                SizedBox(width: 10.0),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Container(
              height: 41.0,
              margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
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
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text('Users',
                    style: TextStyle(
                        color: colorClass.appWhite,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Avenir')),
              )),
          FutureBuilder(
              future: apiService.getAccounts(widget.token!),
              builder: (context, accountsSnapshot) {
                switch (accountsSnapshot.connectionState) {
                  case ConnectionState.none:
                    return customVariables.lightLoadingContainer(
                        '', colorClass.appGrey, true);
                    break;
                  case ConnectionState.waiting:
                    return customVariables.lightLoadingContainer(
                        '', colorClass.appGrey, true);
                    break;
                  case ConnectionState.active:
                    return customVariables.lightLoadingContainer(
                        '', colorClass.appWhite, true);
                    break;
                  case ConnectionState.done:
                    if (accountsSnapshot.hasError) {
                      return Container();
                    } else {
                      if (accountsSnapshot.data != null) {
                        allAccounts =
                            accountsSnapshot.data as List<UserProfile>;
                        if ((filter.isNotEmpty)) {
                          List<UserProfile>? tmpList;
                          for (int i = 0; i < _filteredList.length; i++) {
                            if (_filteredList[i]
                                    .email!
                                    .toLowerCase()
                                    .contains(filter.toLowerCase()) ||
                                _filteredList[i]
                                    .username!
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())) {
                              tmpList!.add(_filteredList[i]);
                            }
                          }
                          _filteredList = tmpList!;
                        } else {
                          _filteredList = allAccounts!;
                        }
                        return accountContent(_filteredList);
                      } else {
                        return Container();
                      }
                    }
                }
                return Container();
              }),
        ],
      ),
    );
  }

  Widget accountContent(List<UserProfile> userList) {
    return Expanded(
        // height: 300,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: allAccounts == null ? 0 : _filteredList.length,
            padding: EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              return Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('USERNAME',
                                  style: TextStyle(
                                      color: colorClass.youtubeBlue,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10.0),
                              Container(
                                constraints: BoxConstraints(maxWidth: 100),
                                child: Text(
                                  userList[index].username!,
                                  style: TextStyle(
                                      color: colorClass.appBlack,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 3,
                                ),
                              ),
                              SizedBox(height: 27.0),
                              Text('EMAIL',
                                  style: TextStyle(
                                      color: colorClass.youtubeBlue,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10.0),
                              Container(
                                constraints: BoxConstraints(maxWidth: 110),
                                child: Text(
                                  userList[index].email!,
                                  style: TextStyle(
                                      color: colorClass.appBlack,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 3,
                                ),
                              ),
                              SizedBox(height: 27.0),
                              Text(variables.status.toUpperCase(),
                                  style: TextStyle(
                                      color: colorClass.youtubeBlue,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Icon(Icons.fiber_manual_record,
                                      size: 11.0,
                                      color: customVariables.getStatusColor(
                                          userList[index].status!)),
                                  SizedBox(width: 3.0),
                                  Text(
                                      customVariables.getSignalStatus(
                                          userList[index].status!),
                                      style: TextStyle(
                                          color: colorClass.appBlack,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400)),
                                ],
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PHONE NUMBER',
                                  style: TextStyle(
                                      color: colorClass.youtubeBlue,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10.0),
                              userList[index].phone_number == null
                                  ? Text('')
                                  : Text(userList[index].phone_number!,
                                      style: TextStyle(
                                          color: colorClass.appBlack,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400)),
                              SizedBox(height: 27.0),
                              Text('REF CODE',
                                  style: TextStyle(
                                      color: colorClass.youtubeBlue,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10.0),
                              userList[index].referral_code == null
                                  ? Text('0')
                                  : Text(userList[index].referral_code!,
                                      style: TextStyle(
                                          color: colorClass.appBlack,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400)),
                              SizedBox(height: 27.0),
                              Text('DATE CREATED',
                                  style: TextStyle(
                                      color: colorClass.youtubeBlue,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10.0),
                              userList[index].created_at == null
                                  ? Text('')
                                  : Text(
                                      customVariables.formatedDate(
                                          userList[index].created_at!),
                                      style: TextStyle(
                                          color: colorClass.appBlack,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400)),
                            ],
                          ),
                          SizedBox(width: 0.0),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Divider(
                      color: colorClass.appGrey,
                      height: 20.0,
                      thickness: 0.5,
                    ),
                  ],
                ),
              );
            }));
  }
}
