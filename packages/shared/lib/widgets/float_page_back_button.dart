import 'package:flutter/material.dart';

class FloatPageBackButton extends StatelessWidget {
  const FloatPageBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Navigator.canPop(context)) {
      return Positioned(
        top: 0 + MediaQuery.of(context).padding.top,
        left: 0,
        child: SizedBox(
          width: kToolbarHeight, // width of the AppBar's leading area
          height: kToolbarHeight, // height of the AppBar's leading area
          child: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_ios_new, size: 16),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
