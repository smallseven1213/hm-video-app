import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';
import '../apps_screen/index.dart';

class HomeAppsScreen extends StatelessWidget {
  const HomeAppsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false, // HC: 煩死，勿動!!
      child: Scaffold(
        appBar: CustomAppBar(
          title: '應用中心',
        ),
        body: AppsScreen(),
      ),
    );
  }
}
