// SearchBar, left is search input, right have 2 buttons

import 'package:app_gp/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/navigator/delegate.dart';

import '../../config/colors.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

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
            child: SearchInput(
              defaultValue: '神级美乳AV女优',
              onTap: () {
                MyRouteDelegate.of(context)
                    .push(AppRoutes.search.value, hasTransition: false);
              },
              autoFocus: false, // 如果需要，可以將此設置為true
            ),
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
