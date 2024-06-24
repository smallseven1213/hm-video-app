import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class VipPage extends StatelessWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'VIP',
      ),
      body: Text('Coming soon...'),
    );
  }
}
