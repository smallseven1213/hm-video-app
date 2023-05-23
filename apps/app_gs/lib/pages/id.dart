import 'package:app_gs/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/id_card.dart';

class IDCardPage extends StatelessWidget {
  const IDCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: '帳號憑證',
      ),
      body: Center(
        child: IDCard(),
      ),
    );
  }
}
