import 'package:flutter/material.dart';

import '../widgets/my_app_bar.dart';

class CoinPage extends StatelessWidget {
  const CoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(
        title: 'Coin',
      ),
      body: Text('CoinPage', style: TextStyle(color: Colors.white)),
    );
  }
}
