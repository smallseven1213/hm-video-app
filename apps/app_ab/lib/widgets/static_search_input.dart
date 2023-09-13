import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

import '../config/colors.dart';

class StaticSearchInput extends StatelessWidget {
  final String defaultValue;
  final VoidCallback onSearchButtonClick;
  final VoidCallback onInputClick;
  const StaticSearchInput({
    Key? key,
    required this.defaultValue,
    required this.onSearchButtonClick,
    required this.onInputClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: onInputClick,
              child: Text(
                defaultValue,
                style: TextStyle(color: AppColors.colors[ColorKeys.textSearch]),
                overflow: TextOverflow.clip,
                maxLines: 1,
              ),
            ),
          ),
          GestureDetector(
            onTap: onSearchButtonClick,
            child: const Center(
                child: Icon(
              Icons.search,
              size: 24,
              color: Colors.grey,
            )),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
