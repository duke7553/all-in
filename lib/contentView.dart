import 'dart:convert';
import 'dart:html';

import 'package:flutter_web/material.dart';
import 'package:html/parser.dart';
import 'feeder.dart';

class ContentReader extends StatefulWidget {
  ContentReader({Key key, this.title, this.feedItem}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final feedItem;

  @override
  ContentReaderState createState() => ContentReaderState();
}

final Feeder feeder = new Feeder();

class ContentReaderState extends State<ContentReader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Reading: Lesson Post",
              style: TextStyle(
                  fontFamily: "IBMPlexSans-Bold", color: Colors.black)),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          backgroundColor: Colors.white,
          centerTitle: true),
      body: Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.network(feeder.imageUrlFromPost(widget.feedItem),
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.noRepeat,
                      height: 200),
                  Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.feedItem["title"],
                            style: TextStyle(
                                fontFamily: "IBMPlexSans-Bold", fontSize: 32),
                          ),
                          Text((widget.feedItem["author"])["displayName"],
                              style: TextStyle(
                                  fontFamily: "IBMPlexSans-Regular",
                                  fontSize: 18)),
                          Text(widget.feedItem["published"],
                              style: TextStyle(
                                  fontFamily: "IBMPlexSans-Regular",
                                  fontSize: 16)),
                          SizedBox(height: 12),
                          Container(
                              child: Text(
                                  Uri.dataFromString(
                                    widget.feedItem["content"]
                                        .toString()
                                        .replaceAll("<br />", "\n")
                                        .replaceAll(RegExp("<(.*?)>"), "")
                                        .replaceAll("&nbsp;", ""),
                                    mimeType: "text/html",
                                  ).data.contentAsString().trimLeft(),
                                  softWrap: true,
                                  style: TextStyle(
                                      fontFamily: "IBMPlexSans-Regular",
                                      fontSize: 16))),
                        ],
                      ))
                ]),
          )),
    );
  }
}
