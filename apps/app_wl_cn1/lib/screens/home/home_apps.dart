import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';
import '../apps_screen/index.dart';

class HomeAppsScreen extends StatelessWidget {
  const HomeAppsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // HC: 烦死，勿动!!
      child: const Scaffold(
        appBar: CustomAppBar(
          title: '应用中心',
        ),
        body: AppsScreen(),
      ),
    );
  }
}
