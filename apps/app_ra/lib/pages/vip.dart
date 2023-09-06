import 'package:flutter/material.dart';

import '../widgets/my_app_bar.dart';

class VipPage extends StatelessWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: '會員中心',
      ),
      body: Container(
        child: Text('vip page', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
