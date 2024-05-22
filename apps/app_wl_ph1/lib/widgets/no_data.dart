import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import '../config/colors.dart';
import '../localization/i18n.dart';
import 'button.dart';
import 'custom_app_bar.dart';

class NoDataWidget extends StatelessWidget {
  final bool showBackButton;
  final String? title;

  const NoDataWidget({
    Key? key,
    this.showBackButton = false,
    this.title = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showBackButton ? CustomAppBar(title: title) : null,
      body: Center(
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
            if (showBackButton)
              Container(
                width: 130,
                padding: const EdgeInsets.only(top: 30),
                child: Button(
                  onPressed: () => Navigator.of(context).pop(),
                  text: I18n.back,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
