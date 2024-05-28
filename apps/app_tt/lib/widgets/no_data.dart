import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import '../config/colors.dart';
import '../localization/i18n.dart';

class NoDataWidget extends StatelessWidget {
  final String? title;

  const NoDataWidget({
    Key? key,
    this.title = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/images/list_no_more.webp'),
            width: 48,
            height: 48,
          ),
          const SizedBox(height: 8),
          Text(I18n.thereIsNothingHere,
              style: TextStyle(color: AppColors.colors[ColorKeys.menuColor])),
        ],
      ),
    );
  }
}
