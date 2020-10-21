import 'feeder.dart';

final Feeder feeder = new Feeder();

Future loadFeeds() async {
  var feed = await feeder.fetchData();
  return feed;
}
