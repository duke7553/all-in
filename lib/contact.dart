import 'dart:convert' as convert;
import 'dart:convert';
import 'package:flutter_web/rendering.dart';
import 'package:flutter_web/material.dart';
import 'package:http/http.dart' as http;

class FeedbackForm {
  String feedback;
  String type;
  String anon;
  String name;
  String grade;
  String info;

  FeedbackForm(
      this.feedback, this.type, this.anon, this.name, this.grade, this.info);

  factory FeedbackForm.fromJson(dynamic jsonp) {
    var json = jsonDecode(jsonp);
    return FeedbackForm(
        "${json['feedback']}",
        fromJsonArray("${json['types']}"),
        "${json['anonymous']}",
        "${json['name']}",
        "${json['grade']}",
        "${json['info']}");
  }

  // Method to make GET parameters.
  Map<String, dynamic> toJson() => {
        'feedback': feedback,
        'types': type,
        'anonymous': anon,
        'name': name,
        'grade': grade,
        'info': info
      };

  static String fromJsonArray(String jsonString) {
    List<dynamic> dynamicList = jsonDecode(jsonString);
    List<String> strings = new List<String>();
    dynamicList.forEach((f) {
      strings.add(f);
    });

    return strings.join(", ");
  }
}

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {
  // Google App Script Web URL.
  static const String URL =
      "https://script.google.com/macros/s/AKfycbwHKRQce53eOsJ9mnwcZsvcgnsVLqvpvFpjhtWbciJb2GdgNOnF/exec";

  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  void submitForm(
      FeedbackForm feedbackForm, void Function(String) callback) async {
    try {
      await http.post(URL, body: feedbackForm.toJson()).then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(url).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
  }
}

class FeedbackWidgetState extends State<FeedbackWidget> {
  String ffeedback = "";
  List<String> ftypes = new List<String>();
  String fotherType = "";
  String fanon = "";
  String fname = "";
  String fgrade = "";
  String finfo = "";
  final List<String> types = [
    "Not very important",
    "Important",
    "Urgent",
    "Feedback about \"All In\"",
    "General feedback about LHS",
    "Information that I need someone trustworthy to see"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Reach Out to Us",
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
        body: Builder(builder: (BuildContext context) {
          submitFeedback() {
            if (fotherType.isNotEmpty) {
              ftypes.add(fotherType);
            }

            if (ffeedback.isNotEmpty && ftypes.isNotEmpty && fanon.isNotEmpty) {
              if (fanon == "Yes, I'll fill out the section below." &&
                  (fgrade.isEmpty || finfo.isEmpty || fname.isEmpty)) {
                final snackBar = SnackBar(
                    content: Text(
                        'Please fill out the required form items and try again'));

                // Find the Scaffold in the widget tree and use it to show a SnackBar.
                Scaffold.of(context).showSnackBar(snackBar);
              } else {
                FeedbackForm feedbackForm = FeedbackForm(
                    ffeedback, ftypes.join(", "), fanon, fname, fgrade, finfo);

                FormController formController = FormController();

                print("Submitting Feedback");

                // Submit 'feedbackForm' and save it in Google Forms.
                formController.submitForm(feedbackForm, (response) {
                  print("Response: $response");
                  if (response == FormController.STATUS_SUCCESS) {
                    final snackBar = SnackBar(
                        content: Text(
                            "Thank you for reaching out to us, we'll review this information and act on it."));

                    // Find the Scaffold in the widget tree and use it to show a SnackBar.
                    Scaffold.of(context).showSnackBar(snackBar);
                  } else {
                    final snackBar = SnackBar(
                        content: Text(
                            "Form was not submitted. Sorry! Please reach out to us in person"));

                    // Find the Scaffold in the widget tree and use it to show a SnackBar.
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                });
              }
            } else {
              final snackBar = SnackBar(
                  content: Text(
                      'Please fill out the required form items and try again'));

              // Find the Scaffold in the widget tree and use it to show a SnackBar.
              Scaffold.of(context).showSnackBar(snackBar);
            }
          }

          return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Form(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Text("What's up? Tell us what's on your mind today.",
                            style: TextStyle(
                                fontFamily: "IBMPlexSans-Bold", fontSize: 24)),
                        TextFormField(
                            autovalidate: true,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText:
                                    "Describe everything you're thinking of in a way that\nfeels comfortable to you."),
                            validator: (value) {
                              ffeedback = value;
                            }),
                        SizedBox(height: 12),
                        Text("How would you describe what you typed above?",
                            style: TextStyle(
                                fontFamily: "IBMPlexSans-Bold", fontSize: 20)),
                        ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: <Widget>[
                            CheckboxListTile(
                                title: Text(types[0]),
                                value: ftypes.contains(types[0]),
                                onChanged: (bool isChecked) {
                                  setState(() {
                                    if (isChecked) {
                                      ftypes.add(types[0]);
                                    } else {
                                      if (ftypes.contains(types[0])) {
                                        ftypes.remove(types[0]);
                                      }
                                    }
                                  });
                                }),
                            CheckboxListTile(
                                title: Text(types[1]),
                                value: ftypes.contains(types[1]),
                                onChanged: (bool isChecked) {
                                  setState(() {
                                    if (isChecked) {
                                      ftypes.add(types[1]);
                                    } else {
                                      if (ftypes.contains(types[1])) {
                                        ftypes.remove(types[1]);
                                      }
                                    }
                                  });
                                }),
                            CheckboxListTile(
                                title: Text(types[2]),
                                value: ftypes.contains(types[2]),
                                onChanged: (bool isChecked) {
                                  setState(() {
                                    if (isChecked) {
                                      ftypes.add(types[2]);
                                    } else {
                                      if (ftypes.contains(types[2])) {
                                        ftypes.remove(types[2]);
                                      }
                                    }
                                  });
                                }),
                            CheckboxListTile(
                                title: Text(types[3]),
                                value: ftypes.contains(types[3]),
                                onChanged: (bool isChecked) {
                                  setState(() {
                                    if (isChecked) {
                                      ftypes.add(types[3]);
                                    } else {
                                      if (ftypes.contains(types[3])) {
                                        ftypes.remove(types[3]);
                                      }
                                    }
                                  });
                                }),
                            CheckboxListTile(
                                title: Text(types[4]),
                                value: ftypes.contains(types[4]),
                                onChanged: (bool isChecked) {
                                  setState(() {
                                    if (isChecked) {
                                      ftypes.add(types[4]);
                                    } else {
                                      if (ftypes.contains(types[4])) {
                                        ftypes.remove(types[4]);
                                      }
                                    }
                                  });
                                }),
                            CheckboxListTile(
                                title: Text(types[5]),
                                value: ftypes.contains(types[5]),
                                onChanged: (bool isChecked) {
                                  setState(() {
                                    if (isChecked) {
                                      ftypes.add(types[5]);
                                    } else {
                                      if (ftypes.contains(types[5])) {
                                        ftypes.remove(types[5]);
                                      }
                                    }
                                  });
                                }),
                            TextFormField(
                                autovalidate: true,
                                decoration:
                                    InputDecoration(hintText: "Other..."),
                                validator: (String value) {
                                  fotherType = value;
                                })
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Do you want to tell us more about yourself?",
                          style: TextStyle(
                              fontFamily: "IBMPlexSans-Bold", fontSize: 20),
                        ),
                        ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            RadioListTile(
                                title: Text(
                                    "I wish to remain Anonymous, and won't fill in the sections below for additional information"),
                                value:
                                    "I wish to remain Anonymous, and won't fill in the sections below for additional information",
                                groupValue: fanon,
                                onChanged: (value) => {
                                      setState(() {
                                        fanon = value;
                                      })
                                    }),
                            RadioListTile(
                                title: Text(
                                    "Yes, I'll fill out the section below."),
                                value: "Yes, I'll fill out the section below.",
                                groupValue: fanon,
                                onChanged: (value) => {
                                      setState(() {
                                        fanon = value;
                                      })
                                    })
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          "Additional Information",
                          style: TextStyle(
                              fontFamily: "IBMPlexSans-Bold", fontSize: 24),
                        ),
                        TextFormField(
                            autovalidate: true,
                            decoration: InputDecoration(
                                hintText: "First and Last Name"),
                            validator: (String value) {
                              fname = value;
                            }),
                        DropdownButtonFormField(
                          items: <DropdownMenuItem>[
                            DropdownMenuItem(
                                child: Text("Freshman"), value: "Freshman"),
                            DropdownMenuItem(
                                child: Text("Sophomore"), value: "Sophomore"),
                            DropdownMenuItem(
                                child: Text("Junior"), value: "Junior"),
                            DropdownMenuItem(
                                child: Text("Senior"), value: "Senior")
                          ],
                          hint: Text("Grade"),
                          onChanged: (value) {
                            fgrade = value;
                          },
                        ),
                        TextFormField(
                            autovalidate: true,
                            decoration: InputDecoration(
                                hintText: "Email or Phone Number"),
                            validator: (String value) {
                              finfo = value;
                            }),
                        RaisedButton(
                          onPressed: () => {submitFeedback()},
                          child: Text("Submit"),
                        )
                      ]))));
        }));
  }
}

class FeedbackWidget extends StatefulWidget {
  FeedbackWidget({Key key}) : super(key: key);

  @override
  FeedbackWidgetState createState() => FeedbackWidgetState();
}
