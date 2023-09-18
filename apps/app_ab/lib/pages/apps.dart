import 'package:flutter/material.dart';

import '../screens/apps_screen/index.dart';
import '../widgets/custom_app_bar.dart';

class AppsPage extends StatelessWidget {
  const AppsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: '應用中心',
      ),
      body: AppsScreen(),
    );
  }
}
