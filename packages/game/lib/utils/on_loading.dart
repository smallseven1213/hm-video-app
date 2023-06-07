import 'package:flutter/material.dart';

void onLoading(BuildContext context, {status}) {
  if (status == true) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            color: Color.fromARGB(208, 255, 255, 255),
          ),
        );
      },
    );
  } else {
    Navigator.pop(context);
  }
}
