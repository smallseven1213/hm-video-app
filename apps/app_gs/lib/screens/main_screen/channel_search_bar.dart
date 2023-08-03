import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_search_history_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/popular_search_title_builder.dart';
import '../../widgets/static_search_input.dart';

class ChannelSearchBar extends StatelessWidget {
  const ChannelSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 30,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 13),
            child: Image(
              image: AssetImage('assets/images/home_search_bar_logo.png'),
              width: 24.0,
              height: 27.0,
            ),
          ),
          // input
          Expanded(
            child: PopularSearchTitleBuilder(
              child: (({required String searchKeyword}) => StaticSearchInput(
                    defaultValue: searchKeyword,
                    onSearchButtonClick: () {
                      MyRouteDelegate.of(context).push(AppRoutes.search, args: {
                        'inputDefaultValue': searchKeyword,
                        'autoSearch': true
                      });
                      Get.find<UserSearchHistoryController>()
                          .add(searchKeyword);
                    },
                    onInputClick: () {
                      MyRouteDelegate.of(context).push(AppRoutes.search, args: {
                        'inputDefaultValue': searchKeyword,
                        'autoSearch': false
                      });
                    },
                  )),
            ),
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
                    width: 24,
                    height: 24,
                    child: Image(
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
