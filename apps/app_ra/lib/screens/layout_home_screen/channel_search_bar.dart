import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_search_history_controller.dart';
import 'package:shared/controllers/video_popular_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/home_navigator_pathes.dart';
import 'package:shared/modules/main_navigation/main_navigation_link_button.dart';
import 'package:shared/navigator/delegate.dart';

import '../../widgets/avatar.dart';
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
          const SizedBox(
            width: 10,
          ),
          MainNavigationLinkButton(
            screenKey: HomeNavigatorPathes.user,
            child: Avatar(
              width: 30,
              height: 60,
            ),
          ),
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
                    'autoSearch': true
                  });
                },
              );
            }),
          ),
          GestureDetector(
            onTap: () {
              MyRouteDelegate.of(context).push(AppRoutes.filter);
            },
            child: const SizedBox(
                width: 20,
                height: 60,
                // color: AppColors.colors[ColorKeys.background],
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          'assets/images/home_search_bar_filter.png'),
                    ),
                  ),
                )),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
