import 'package:app_ra/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/id_card.dart';

class IDCardPage extends StatelessWidget {
  const IDCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(
        title: '帳號憑證',
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: IDCard(),
      ),
    );
  }
}
