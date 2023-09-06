import 'package:flutter/material.dart';

import '../widgets/my_app_bar.dart';

class CoinPage extends StatelessWidget {
  const CoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: '會員中心',
      ),
      body: Container(
        child: Text('coin page', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
