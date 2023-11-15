import 'package:flutter/material.dart';

class FloatPageBackButton extends StatelessWidget {
  const FloatPageBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Navigator.canPop(context)) {
      return Positioned(
        top: 0,
        left: 8,
        child: Container(
          width: 31, // width of the AppBar's leading area
          height: 31, // height of the AppBar's leading area
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            color: Colors.white,
            icon: const Icon(Icons.arrow_back_ios_new, size: 15),
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
