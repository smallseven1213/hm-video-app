// SearchBar, left is search input, right have 2 buttons

import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

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
          // button
          Container(
            width: 60,
            height: 60,
            color: AppColors.colors[ColorKeys.background],
            child: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          // input
          Expanded(
            child: Container(
              height: 60,
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.center,
              color: AppColors.colors[ColorKeys.background],
              child: const TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            color: AppColors.colors[ColorKeys.background],
            child: const Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
