import 'package:app_wl_id1/localization/i18n.dart';
import 'package:app_wl_id1/widgets/custom_app_bar.dart';
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
