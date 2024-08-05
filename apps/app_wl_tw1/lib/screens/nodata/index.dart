import 'package:flutter/material.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/no_data.dart';

class NoDataScreen extends StatelessWidget {
  final bool showBackButton;
  final String? title;

  const NoDataScreen({
    Key? key,
    this.showBackButton = true,
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
            const NoDataWidget(),
            if (showBackButton)
              Container(
                width: 130,
                padding: const EdgeInsets.only(top: 30),
                child: Button(
                  onPressed: () => Navigator.of(context).pop(),
                  text: '返回',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
