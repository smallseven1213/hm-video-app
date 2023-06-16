import 'package:flutter/material.dart';
import 'package:game/utils/loading.dart';

void onLoading(BuildContext context, {status}) {
  if (status == true) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: GameLoading(),
        );
      },
    );
  } else {
    Navigator.pop(context);
  }
}
