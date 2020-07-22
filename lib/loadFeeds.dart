// @JS()
// library load_feeds_function;

import 'feeder.dart';

// @JS('loadFeed')
// external set _loadFeed(void Function() f);

// @JS()
// external void loadFeed();

final Feeder feeder = new Feeder();

Future loadFeeds() async {
  // if (feedIndexDB != null) {
  //   return feedIndexDB;
  // } else {
  var feed = await feeder.fetchData();
  return feed;
  //}
}

// @JS('feedStore')
// var feedIndexDB;

// void main() {
//   _loadFeed = allowInterop(loadFeeds);
// }
