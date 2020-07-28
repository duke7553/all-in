import 'dart:ui';

import 'package:all_in/contact.dart';
import 'package:all_in/contentView.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'feeder.dart';
import 'package:flutter/material.dart';

import 'loadFeeds.dart';

void main() {
  runApp(MyApp());
}

int _selectedIndex = 0;
Map<int, Color> color = {
  50: Color.fromRGBO(183, 28, 28, .1),
  100: Color.fromRGBO(183, 28, 28, .2),
  200: Color.fromRGBO(183, 28, 28, .3),
  300: Color.fromRGBO(183, 28, 28, .4),
  400: Color.fromRGBO(183, 28, 28, .5),
  500: Color.fromRGBO(183, 28, 28, .6),
  600: Color.fromRGBO(183, 28, 28, .7),
  700: Color.fromRGBO(183, 28, 28, .8),
  800: Color.fromRGBO(183, 28, 28, .9),
  900: Color.fromRGBO(183, 28, 28, 1),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All In',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        canvasColor: Colors.white,
        primarySwatch: MaterialColor(0xFFb71c1c, color),
        accentColor: Color(0xFFb71c1c),
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'All In'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StatelessWidget bodyWidget = LessonsPageState();
  void getBodyFromSelectedIndex() {
    setState(() {
      if (_selectedIndex == 0) {
        bodyWidget = LessonsPageState();
      } else if (_selectedIndex == 1) {
        bodyWidget = SchedulePageState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Stack(children: [
      Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title,
                style: GoogleFonts.ibmPlexSans(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
          ),
          body: bodyWidget,
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: , // This trailing comma makes auto-formatting nicer for build methods.
          bottomNavigationBar: BottomAppBar(
              shape: AutomaticNotchedShape(
                  RoundedRectangleBorder(), StadiumBorder()),
              notchMargin: 5.0,
              elevation: 12.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: SizedBox(
                    height: 60,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: onLessonsInvoked,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.lightbulb_outline,
                                color: _selectedIndex == 0
                                    ? Color.fromRGBO(183, 28, 28, 1)
                                    : Colors.black),
                            Text("Lessons",
                                style: GoogleFonts.ibmPlexSans(
                                    color: _selectedIndex == 0
                                        ? Color.fromRGBO(183, 28, 28, 1)
                                        : Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  )),
                  SizedBox(width: 50),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: _onScheduleInvoked,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.info_outline,
                                  color: _selectedIndex == 1
                                      ? Color.fromRGBO(183, 28, 28, 1)
                                      : Colors.black),
                              Text("About",
                                  style: GoogleFonts.ibmPlexSans(
                                      color: _selectedIndex == 1
                                          ? Color.fromRGBO(183, 28, 28, 1)
                                          : Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ))),
      Transform.translate(
          offset: Offset(0, -30),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton.extended(
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      label: Text("Let's talk",
                          style: GoogleFonts.ibmPlexSans(
                              fontWeight: FontWeight.w500)),
                      onPressed: contactInvoked,
                      tooltip: 'We\'re always here for you',
                      elevation: 3.25,
                      isExtended: true,
                      icon: Icon(Icons.chat),
                    )
                  ])))
    ]);
  }

  void _onScheduleInvoked() {
    _selectedIndex = 1;
    this.setState(() {
      getBodyFromSelectedIndex();
    });
  }

  void contactInvoked() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FeedbackWidget()));
  }

  void onLessonsInvoked() {
    _selectedIndex = 0;
    this.setState(() {
      getBodyFromSelectedIndex();
    });
  }
}

class SchedulePageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

final Feeder feeder = new Feeder();

class LessonsPageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadFeeds(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverPersistentHeader(
                      pinned: false, delegate: TextHeading()),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    var post = snapshot.data[index];
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContentReader(
                                        feedItem: snapshot.data[index],
                                      )));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            feeder.imageUrlFromPost(post) != null
                                ? ClipRRect(
                                    child: Image.network(
                                        feeder.imageUrlFromPost(post),
                                        filterQuality: FilterQuality.low,
                                        fit: BoxFit.cover,
                                        height: 200,
                                        repeat: ImageRepeat.noRepeat,
                                        cacheHeight: 200),
                                    borderRadius: BorderRadius.circular(4))
                                : SizedBox(
                                    height: 1,
                                  ),
                            Text(post["title"],
                                style: GoogleFonts.ibmPlexSans(
                                    fontSize: 22, fontWeight: FontWeight.w600)),
                            Text(
                                parse(post["content"]).body.text.length > 99
                                    ? parse(post["content"])
                                            .body
                                            .text
                                            .substring(0, 100)
                                            .trimLeft() +
                                        "..."
                                    : parse(post["content"]).body.text,
                                style: GoogleFonts.ibmPlexSans()),
                            SizedBox(height: 20)
                          ],
                        ));
                  }, childCount: snapshot.data.length))
                ],
              ),
            ),
          );
        } else {
          return Align(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Loading ", style: GoogleFonts.ibmPlexSans()),
                    CircularProgressIndicator()
                  ]));
        }
      },
    );
  }
}

class TextHeading extends SliverPersistentHeaderDelegate {
  String heading;
  String subHeading;

  getRelevantHeadings() {
    if (DateTime.now().month == DateTime.august ||
        DateTime.now().month == DateTime.july) {
      heading = "Don't do good. Do better.";
      subHeading = "Dive right in to your new source of continuous improvement";
    } else {
      var dayOfWeek = DateTime.now().weekday;
      switch (dayOfWeek) {
        case DateTime.wednesday:
          heading = "It's Wednesday my dudes!";
          subHeading = "Only you can power through your obstacles";
          break;
        case DateTime.thursday:
          heading = "Welcome";
          subHeading = "We're glad you're here";
          break;
        case DateTime.friday:
          heading = "Happy Friday!";
          subHeading = "Take some time to reflect on what you heard this week";
          break;
        case DateTime.saturday:
          heading = "Welcome";
          subHeading = "School may be closed, but we've got you covered";
          break;
        case DateTime.sunday:
          heading = "Welcome";
          subHeading = "School may be closed, but we've got you covered";
          break;
        default: // Monday and Tuesday
          heading = "You can do it!";
          subHeading = "Get through the week with motivating lessons";
          break;
      }
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    getRelevantHeadings();
    return LayoutBuilder(builder: (context, constraints) {
      return Column(children: <Widget>[
        Container(
          height: constraints.maxHeight,
          child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(heading,
                        style: GoogleFonts.ibmPlexSans(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    Text(subHeading,
                        style: GoogleFonts.ibmPlexSans(fontSize: 18)),
                  ])),
        ),
      ]);
    });
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
