import 'package:blueprint_app2/utils.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({Key? key, this.image}) : super(key: key);
  final String? image;
  @override
  State<StatefulWidget> createState() {
    WidgetsFlutterBinding.ensureInitialized();
    return _ImageState();
  }
}

class _ImageState extends State<ImageViewer> {
  String? image;
  ColorClass colorClass = ColorClass();
  Variables variables = Variables();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: colorClass.appBlack,
        appBar: AppBar(
          backgroundColor: colorClass.appBlue,
          title: Text(
            'Signal Image',
            style: TextStyle(
              color: colorClass.appWhite,
              fontFamily: 'Avenir',
            ),
          ),
          elevation: 0.0,
        ),
        body: viewImage(context, widget.image!));
  }

  Center viewImage(BuildContext context, String image) {
    return Center(
      child: Image(image: NetworkImage(variables.imagebaseLink + image)),
    );
  }
}
