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
    return SizedBox(
      height: 30,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
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
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              MyRouteDelegate.of(context).push(AppRoutes.filter);
            },
            child: const Center(
              child: Icon(
                Icons.filter_alt_outlined,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
