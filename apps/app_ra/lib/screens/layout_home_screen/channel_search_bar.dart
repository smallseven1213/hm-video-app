import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_search_history_controller.dart';
import 'package:shared/controllers/video_popular_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../../widgets/static_search_input.dart';

class ChannelSearchBar extends StatelessWidget {
  ChannelSearchBar({Key? key}) : super(key: key);

  final VideoPopularController videoPopularController =
      Get.find<VideoPopularController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Obx(() {
              int listLength = videoPopularController.data.length;
              String randomTitle = '';
              if (listLength > 0) {
                int randomIndex = Random().nextInt(listLength);
                randomTitle = videoPopularController.data[randomIndex].title;
              }
              return StaticSearchInput(
                defaultValue: randomTitle,
                onSearchButtonClick: () {
                  MyRouteDelegate.of(context).push(AppRoutes.search, args: {
                    'inputDefaultValue': randomTitle,
                    'autoSearch': true
                  });
                  Get.find<UserSearchHistoryController>().add(randomTitle);
                },
                onInputClick: () {
                  MyRouteDelegate.of(context).push(AppRoutes.search, args: {
                    'inputDefaultValue': randomTitle,
                    'autoSearch': false
                  });
                },
              );
            }),
          ),
          GestureDetector(
            onTap: () {
              MyRouteDelegate.of(context).push(AppRoutes.filter);
            },
            child: Container(
                width: 40,
                height: 60,
                // color: AppColors.colors[ColorKeys.background],
                child: const Center(
                  child: SizedBox(
                    width: 17,
                    height: 17,
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          'assets/images/home_search_bar_filter.png'),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
