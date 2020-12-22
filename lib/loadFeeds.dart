import 'package:flutter/cupertino.dart';

import 'feeder.dart';
import 'main.dart';

final Feeder feeder = new Feeder();

Future loadFeeds() async {
  List<FeedItemModel> feedItemsList = [];
  var feed = await feeder.fetchData();
  for (var feedItem in feed) {
    FeedItemModel fItemModel = new FeedItemModel();
    fItemModel.rawPost = feedItem;

    if (feeder.imageUrlFromPost(feedItem) != null) {
      fItemModel.feedImage = Image.network(feeder.imageUrlFromPost(feedItem),
          filterQuality: FilterQuality.low,
          fit: BoxFit.cover,
          height: 200,
          repeat: ImageRepeat.noRepeat,
          cacheHeight: 200);
    } else {
      fItemModel.feedImage = Image.network(
          LessonsPageState.getPlaceholderImageUrl(),
          filterQuality: FilterQuality.low,
          fit: BoxFit.cover,
          height: 200,
          repeat: ImageRepeat.noRepeat,
          cacheHeight: 200);
    }

    feedItemsList.add(fItemModel);
  }
  return feedItemsList;
}

class FeedItemModel {
  var rawPost;
  Image feedImage;
}
