import 'package:app_gs/localization/i18n.dart';
import 'package:flutter/material.dart';

class ReloadButton extends StatelessWidget {
  final Function? onPressed;
  const ReloadButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(I18n.inputAbnormal,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.3))),
        Text(I18n.pleaseReload,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.3))),
        IconButton(
          onPressed: () => onPressed!(),
          icon: const Icon(
            Icons.refresh,
            color: Color.fromRGBO(255, 255, 255, 0.3),
            size: 22,
          ),
        ),
      ],
    );
  }
}
