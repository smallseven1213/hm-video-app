import 'package:flutter/material.dart';

void showCustomModalBottomSheet(
  BuildContext context, {
  required Widget child,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: child,
      );
    },
  );
}
