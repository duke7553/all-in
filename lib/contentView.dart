// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feeder.dart';
import 'loadFeeds.dart';

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
  final FeedItemModel feedItem;

  @override
  ContentReaderState createState() => ContentReaderState();
}

extension on TextStyle {
  /// Temporary fix the following Flutter Web issues
  /// https://github.com/flutter/flutter/issues/63467
  /// https://github.com/flutter/flutter/issues/64904#issuecomment-699039851
  /// https://github.com/flutter/flutter/issues/65526
  TextStyle get withZoomFix => copyWith(wordSpacing: 0);
}

final Feeder feeder = new Feeder();

class ContentReaderState extends State<ContentReader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Reading: Lesson Post",
              style: GoogleFonts.ibmPlexSans(
                      color: Colors.black, fontWeight: FontWeight.bold)
                  .withZoomFix),
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
                  widget.feedItem.feedImage,
                  Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.feedItem.rawPost["title"],
                            style: GoogleFonts.ibmPlexSans(
                                    fontWeight: FontWeight.bold, fontSize: 32)
                                .withZoomFix,
                          ),
                          Text(
                              (widget
                                  .feedItem.rawPost["author"])["displayName"],
                              style: GoogleFonts.ibmPlexSans(fontSize: 18)
                                  .withZoomFix),
                          Text(widget.feedItem.rawPost["published"],
                              style: GoogleFonts.ibmPlexSans(fontSize: 16)
                                  .withZoomFix),
                          SizedBox(height: 12),
                          Container(
                              child: Text(
                                  Uri.dataFromString(
                                    widget.feedItem.rawPost["content"]
                                        .toString()
                                        .replaceAll("<br />", "\n")
                                        .replaceAll(RegExp("<(.*?)>"), "")
                                        .replaceAll("&nbsp;", ""),
                                    mimeType: "text/html",
                                  ).data.contentAsString().trimLeft(),
                                  softWrap: true,
                                  style: GoogleFonts.ibmPlexSerif(fontSize: 16)
                                      .withZoomFix)),
                        ],
                      ))
                ]),
          )),
    );
  }
}
