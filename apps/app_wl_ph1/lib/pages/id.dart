import 'package:app_gs/localization/i18n.dart';
import 'package:app_gs/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/id_card.dart';

class IDCardPage extends StatelessWidget {
  const IDCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: I18n.accountCredentials,
      ),
      extendBodyBehindAppBar: true,
      body: const Center(
        child: IDCard(),
      ),
    );
  }
}
