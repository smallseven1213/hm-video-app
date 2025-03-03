import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/models/color_keys.dart';

import '../config/colors.dart';

class StaticSearchInput extends StatelessWidget {
  final bool isWhiteTheme;
  final String defaultValue;
  final VoidCallback onSearchButtonClick;
  final VoidCallback onInputClick;
  const StaticSearchInput({
    Key? key,
    this.isWhiteTheme = false,
    required this.defaultValue,
    required this.onSearchButtonClick,
    required this.onInputClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      // color: AppColors.colors[ColorKeys.background],
      child: SizedBox(
        height: 30,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color(0xFF00B2FF),
          ),
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: isWhiteTheme
                    ? Colors.white
                    : AppColors.colors[ColorKeys.background]),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: onInputClick,
                    child: Text(
                      defaultValue,
                      style: TextStyle(
                          color: isWhiteTheme
                              ? const Color(0xFF21A8F8)
                              : Colors.white),
                      overflow: TextOverflow.clip, // 使用 clip，當文字超出邊界時將其裁剪
                      maxLines: 1, // 限制最大行數為 1，這樣文字就不會換行
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onSearchButtonClick,
                  child: const SizedBox(
                    width: 17,
                    height: 17,
                    child: Image(
                      image: AssetImage('assets/images/search_button.png'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
