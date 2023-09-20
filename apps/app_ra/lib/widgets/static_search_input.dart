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
            children: [
              const SizedBox(width: 4),
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
              Center(
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 17,
                  ),
                  onPressed: onInputClick,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
