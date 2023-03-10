// SearchBar, left is search input, right have 2 buttons

import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

import '../../config/colors.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.colors[ColorKeys.background],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [],
      ),
    );
  }
}
