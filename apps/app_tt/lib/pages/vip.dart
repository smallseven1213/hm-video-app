import 'package:flutter/material.dart';

import '../widgets/my_app_bar.dart';

class VipPage extends StatelessWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(
        title: 'VIP',
      ),
      body: Text('VIP page', style: TextStyle(color: Colors.white)),
    );
  }
}
