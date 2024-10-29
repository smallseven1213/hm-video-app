import 'package:app_wl_tw2/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:app_wl_tw2/localization/i18n.dart';

class VipPage extends StatelessWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: I18n.vip,
      ),
      body: const Text('VIP page', style: TextStyle(color: Colors.white)),
    );
  }
}
