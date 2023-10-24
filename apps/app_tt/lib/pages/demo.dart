import 'package:app_tt/localization/i18n.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../widgets/button.dart';
import '../widgets/my_app_bar.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  bool isFirstLocale = true;

  void onPressed() async {
    isFirstLocale = !isFirstLocale;
    await context.setLocale(isFirstLocale
        ? EasyLocalization.of(context)!.supportedLocales[0]
        : EasyLocalization.of(context)!.supportedLocales[1]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: I18n.appCenter,
      ),
      body: Center(
        child: Button(
          onPressed: onPressed,
          text: "換語系",
        ),
      ),
    );
  }
}
