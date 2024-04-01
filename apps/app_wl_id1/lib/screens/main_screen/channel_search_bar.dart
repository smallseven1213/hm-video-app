import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_search_history_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/popular_search_title_builder.dart';
import '../../widgets/static_search_input.dart';

class ChannelSearchBar extends StatelessWidget {
  final bool isWhiteTheme;
  const ChannelSearchBar({Key? key, this.isWhiteTheme = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isWhiteTheme ? Colors.white : Colors.transparent,
      height: 30,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: PopularSearchTitleBuilder(
              child: (({required String searchKeyword}) => StaticSearchInput(
                    isWhiteTheme: isWhiteTheme,
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
          // width 10
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              MyRouteDelegate.of(context).push(AppRoutes.filter);
            },
            child: const Image(
              image: AssetImage('assets/images/search_filters.png'),
              fit: BoxFit.contain,
              height: 24,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
