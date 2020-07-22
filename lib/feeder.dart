import 'dart:async';
import 'dart:convert';

import 'package:html/parser.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Feeder {
  //Function to fetch data from JSON instead
  Future fetchData() async {
    print("attempting");
    final url =
        "https://www.googleapis.com/blogger/v3/blogs/6446146598590792727/posts/?key=AIzaSyCGIGijPUC5H4tjm4a3YuNdvS6NRv2h8j8";
    var file = await DefaultCacheManager().getSingleFile(url);
    if (file != null) {
      final Map items = json.decode(await file.readAsString());
      return items['items'];
    }
  }

  String imageUrlFromPost(var post) {
    var postContent = post["content"];
    var document = parse(postContent);
    RegExp regExp = new RegExp(
      r"(https?:\/\/.*\.(?:png|jpg|gif))",
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.stringMatch(document.outerHtml.toString()).toString();
    if (match.length > 5) {
      if (match.contains(".jpg")) {
        return match.substring(0, match.indexOf(".jpg"));
      } else if (match.contains(".png")) {
        return match.substring(0, match.indexOf(".png"));
      }
    }
    return null;
  }
}
