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
                // padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.center,
                color: AppColors.colors[ColorKeys.background],
                child: SizedBox(
                  height: 30,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF00B2FF),
                          Color(0xFFCCEAFF),
                          Color(0xFF0075FF),
                        ],
                        stops: [0, 0.5, 1],
                      ),
                    ),
                    padding: const EdgeInsets.all(
                        2), // Set the width of the gradient border
                    child: const TextField(
                      textAlignVertical: TextAlignVertical
                          .center, // Vertically center the input text
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Color(
                            0xFF002865), // Set the background color of the input
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
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
