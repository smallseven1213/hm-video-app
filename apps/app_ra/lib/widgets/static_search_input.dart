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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 37,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(
              color: AppColors.colors[ColorKeys.textPrimary]!, width: 2),
          // color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  size: 16,
                ),
                onPressed: onInputClick,
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: onInputClick,
                  child: Text(
                    defaultValue,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // Container(
              //   width: 50,
              //   alignment: Alignment.center,
              //   decoration: const BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(10)),
              //     color: Color(0xFFFF3B52),
              //   ),
              //   child: TextButton(
              //     onPressed: onSearchButtonClick,
              //     child: const Text(
              //       '搜索',
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
