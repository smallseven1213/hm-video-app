import 'dart:math';

import 'package:app_gp/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_popular_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/navigator/delegate.dart';

import '../../config/colors.dart';

class SearchBar extends StatelessWidget {
  SearchBar({Key? key}) : super(key: key);

  final VideoPopularController videoPopularController =
      Get.find<VideoPopularController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              width: 40,
              height: 60,
              color: AppColors.colors[ColorKeys.background],
              child: const Image(
                image: AssetImage('assets/images/home_search_bar_logo.png'),
                width: 50.0,
                height: 50.0,
              ),
            ),
          ),
          // input
          Expanded(
            child: Obx(() {
              int listLength = videoPopularController.data.length;
              int randomIndex = Random().nextInt(listLength);
              String randomTitle = videoPopularController.data.isNotEmpty
                  ? videoPopularController.data[randomIndex].title
                  : '';

              return SearchInput(
                defaultValue: randomTitle,
                readOnly: true,
                enableInteractiveSelection: false,
                onSearchButtonClick: () {
                  MyRouteDelegate.of(context).push(AppRoutes.search.value,
                      hasTransition: false,
                      args: {
                        'inputDefaultValue': randomTitle,
                      });
                },
                onTap: () {
                  MyRouteDelegate.of(context).push(AppRoutes.search.value,
                      hasTransition: false,
                      args: {
                        'inputDefaultValue': randomTitle,
                        'dontSearch': true
                      });
                },
                autoFocus: false, // 如果需要，可以將此設置為true
              );
            }),
          ),
          InkWell(
            onTap: () {
              MyRouteDelegate.of(context)
                  .push(AppRoutes.filter.value, hasTransition: false);
            },
            child: Container(
              width: 40,
              height: 60,
              color: AppColors.colors[ColorKeys.background],
              child: const Image(
                image: AssetImage('assets/images/home_search_bar_filter.png'),
                width: 50.0,
                height: 50.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
