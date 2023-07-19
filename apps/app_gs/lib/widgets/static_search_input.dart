import 'package:flutter/foundation.dart';
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
      height: 60,
      alignment: Alignment.center,
      // color: AppColors.colors[ColorKeys.background],
      child: SizedBox(
        height: 30,
        child: Container(
          decoration: kIsWeb
              ? const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xFF00B2FF),
                )
              : const BoxDecoration(
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
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: AppColors.colors[ColorKeys.background]),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: onInputClick,
                    child: Text(
                      defaultValue,
                      style: const TextStyle(color: Colors.white),
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
