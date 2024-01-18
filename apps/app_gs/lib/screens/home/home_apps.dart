import 'package:app_gs/localization/i18n.dart';
// HomeAppsScreen is a staltess widget which has no any containt.

import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';
import '../apps_screen/index.dart';

class HomeAppsScreen extends StatelessWidget {
  const HomeAppsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // HC: 煩死，勿動!!
      child: Scaffold(
        appBar: CustomAppBar(
          title: I18n.appCenter,
        ),
        body: const AppsScreen(),
      ),
    );
  }
}
