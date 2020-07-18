import 'dart:async';

import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart';

class Feeder {
  Future getFeed(String url) async {
    print("fetching $url ... ");
    var response = await get(url);
    print("fetched with code: ${response.statusCode}");
    return AtomFeed.parse(response.body);
  }
}
