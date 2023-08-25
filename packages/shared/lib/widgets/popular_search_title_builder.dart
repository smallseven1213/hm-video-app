import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../controllers/video_popular_controller.dart';

class PopularSearchTitleBuilder extends StatelessWidget {
  const PopularSearchTitleBuilder({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget Function({required String searchKeyword}) child;

  @override
  Widget build(BuildContext context) {
    final VideoPopularController videoPopularController =
        Get.find<VideoPopularController>();
    return Obx(() {
      int listLength = videoPopularController.data.length;
      String randomTitle = '';
      if (listLength > 0) {
        int randomIndex = Random().nextInt(listLength);
        randomTitle = videoPopularController.data[randomIndex].title;
      }
      return child(searchKeyword: randomTitle);
    });
  }
}
