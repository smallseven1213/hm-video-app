import 'package:flutter/material.dart';

void showCustomModalBottomSheet(
  BuildContext context, {
  required Widget child,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          // border: Border.all(
          //   color: Theme.of(context).colorScheme.primary,
          //   width: 1,
          // ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    },
  );
}
