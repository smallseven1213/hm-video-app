import 'package:app_wl_tw2/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class VipPage extends StatelessWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'VIP',
      ),
      body: Text('VIP page', style: TextStyle(color: Colors.white)),
    );
  }
}
