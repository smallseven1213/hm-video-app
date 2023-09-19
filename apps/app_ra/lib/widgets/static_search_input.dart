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
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                    overflow: TextOverflow
                        .ellipsis, // This line ensures that the text gets truncated
                    maxLines:
                        1, // This line ensures that the text stays in one line
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
