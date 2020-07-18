import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:webfeed/domain/atom_item.dart';
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
  final AtomItem feedItem;

  @override
  ContentReaderState createState() => ContentReaderState();
}

class ContentReaderState extends State<ContentReader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Reading: Lesson Post",
              style: GoogleFonts.ibmPlexSans(
                  color: Colors.black, fontWeight: FontWeight.bold)),
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          centerTitle: true),
      body: Align(
        alignment: Alignment.topLeft,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.network(widget.feedItem.media.thumbnails.first.url,
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.noRepeat,
                  height: 200,
                  cacheHeight: 200),
              Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.feedItem.title,
                        style: GoogleFonts.ibmPlexSans(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                      SelectableText(
                        parse(widget.feedItem.content).body.text.trimLeft(),
                        style: GoogleFonts.ibmPlexSerif(fontSize: 18),
                      )
                    ],
                  ))
            ]),
      ),
    );
  }
}
