import 'package:flutter/material.dart';

import '../localization/i18n.dart';
import '../screens/apps_screen/index.dart';
import '../widgets/custom_app_bar.dart';

class AppsPage extends StatelessWidget {
  const AppsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: I18n.appCenter,
      ),
      body: const AppsScreen(),
    );
  }
}
