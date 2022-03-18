import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:untitled1/data/models/story.dart';

class StoryScreen extends StatelessWidget {
  List<Story> storiesDetails;

  StoryScreen(this.storiesDetails, {Key? key}) : super(key: key);

  final controller = StoryController();

  @override
  Widget build(context) {
    // List<StoryItem> stories = storiesDetails
    //     .map((storyDetails) => StoryItem.pageImage(
    //         url: storyDetails.storyImageUrl!, controller: controller))
    //     .toList();

    List<StoryItem> stories = [];
    for (var element in storiesDetails) {
      stories.add(StoryItem.pageImage(
          url: element.storyImageUrl!, controller: controller));
    }

    // List<StoryItem> storyItems = [
    //   StoryItem.pageImage(
    //       url:
    //       'https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg',
    //       controller: controller),
    //   StoryItem.pageImage(
    //       url: 'https://www.neappoli.com/static/media/flutterImg.94b8139a.png',
    //       controller: controller),
    //   StoryItem.pageImage(
    //       url:
    //       'https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg',
    //       controller: controller),
    //   StoryItem.pageImage(
    //       url: 'https://www.neappoli.com/static/media/flutterImg.94b8139a.png',
    //       controller: controller),
    //   StoryItem.pageImage(
    //       url:
    //       'https://wirepicker.com/wp-content/uploads/2021/09/android-vs-ios_1200x675.jpg',
    //       controller: controller),
    //   StoryItem.pageImage(
    //       url: 'https://www.neappoli.com/static/media/flutterImg.94b8139a.png',
    //       controller: controller),
    // ]; // your list of stories

    return StoryView(
      controller: controller,
      // pass controller here too
      repeat: false,
      // should the stories be slid forever
      onStoryShow: (s) {
        // notifyServer(s)
      },
      onComplete: () {
        Navigator.pop(context);
      },
      onVerticalSwipeComplete: (direction) {
        if (direction == Direction.down) {
          Navigator.pop(context);
        }
      },
      storyItems: stories,
    );
  }
}