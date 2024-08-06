import 'package:blueprint_app2/model/signal/signal_data.dart';
import 'package:blueprint_app2/ui/screens/image_viewer.dart';
import 'package:blueprint_app2/utils.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignalView extends StatefulWidget {
  const SignalView({Key? key, required this.signal}) : super(key: key);
  final Signals signal;
  @override
  State<StatefulWidget> createState() {
    WidgetsFlutterBinding.ensureInitialized();
    return _SignalState();
  }
}

class _SignalState extends State<SignalView> {
  // Signals? _signals;
  ColorClass colorClass = ColorClass();
  Variables variables = Variables();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    widget.signal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorClass.appBlack,
      appBar: AppBar(
        backgroundColor: colorClass.appBlue,
        title: Text(
          variables.tradeParam,
          style: TextStyle(
            color: colorClass.appWhite,
            fontFamily: 'Avenir',
          ),
        ),
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            height: 150.0,
            color: colorClass.appBlue,
          ),
          _signalData(context, widget.signal)
        ],
      ),
    );
  }

  Container _signalData(BuildContext context, Signals signals) {
    return Container(
        margin: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageViewer(image: signals.image)),
                );
              },
              child: Container(
                height: 200.0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: signalImage(signals.image!),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      child: Text(
                        formatedDate(signals.created_at!),
                        style: TextStyle(
                            color: colorClass.appWhite,
                            fontWeight: FontWeight.normal,
                            fontSize: 10.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 22.0),
                  itemsContainer(context, variables.symbol, signals.symbol!),
                  Divider(
                    height: 30.0,
                    color: colorClass.appGrey,
                  ),
                  itemsContainer(
                      context, variables.timeFrame, signals.time_frame!),
                  Divider(
                    height: 30.0,
                    color: colorClass.appGrey,
                  ),
                  itemsContainer(
                      context, variables.tradetype, signals.trade_type!),
                  Divider(
                    height: 30.0,
                    color: colorClass.appGrey,
                  ),
                  signals.entry_price_one != null
                      ? itemsContainer(context, variables.entryPrice1,
                          signals.entry_price_one!)
                      : Container(),
                  Divider(
                    height: 30.0,
                    color: Colors.grey[800],
                  ),
                  signals.entry_price_two != null
                      ? itemsContainer(context, variables.entryPrice2,
                          signals.entry_price_two!)
                      : Text("nil"),
                  Divider(
                    height: 30.0,
                    color: Colors.grey[800],
                  ),
                  signals.stop_loss != null
                      ? itemsContainer(
                          context, variables.stopLoss, signals.stop_loss!)
                      : Text("nil"),
                  Divider(
                    height: 30.0,
                    color: Colors.grey[800],
                  ),
                  signals.take_profit_one != null
                      ? itemsContainer(context, variables.takeProfit1,
                          signals.take_profit_one!)
                      : Text("nil"),
                  Divider(
                    height: 30.0,
                    color: Colors.grey[800],
                  ),
                  signals.take_profit_two != null
                      ? itemsContainer(context, variables.takeProfit2,
                          signals.take_profit_two!)
                      : Text("nil"),
                  Divider(
                    height: 30.0,
                    color: Colors.grey[800],
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      variables.text,
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.0,
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  signals.text != null
                      ? Text(
                          signals.text!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.normal),
                        )
                      : Text("nil")
                ],
              ),
            ),
          ],
        ));
  }

  Image signalImage(String image) {
    return Image.network(variables.imagebaseLink + image,
        height: 200.0,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fitWidth);
  }

  String formatedDate(String dateString) {
    DateTime signalDate = DateTime.parse(dateString);
    print(signalDate);
    return formatDate(signalDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, '', am]);
  }

  Container itemsContainer(BuildContext context, String label, String value) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10.0),
              Text(
                label,
                style: TextStyle(
                  color: colorClass.appWhite,
                  fontSize: 8.0,
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 7.0),
              Text(
                value,
                style: TextStyle(
                    color: colorClass.appWhite,
                    fontSize: 13.0,
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Copy',
                    style: TextStyle(
                        color: colorClass.appWhite,
                        fontSize: 11.0,
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () {
                      copyValue(context, value, label);
                    },
                    child: Icon(
                      Icons.content_copy,
                      color: colorClass.appBlue,
                      size: 24.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  void copyValue(BuildContext context, String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    _showToast("Copied " + label);
  }

  void _showToast(String label) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: Text(label),
      duration: Duration(seconds: 4),
    ));
  }
}
