import 'package:flutter/material.dart';

import '../../widgets/circle_button.dart';

class RightCornerControllers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleButton(
          onTap: () {},
          icon: const Icon(
            Icons.share,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 15),
        CircleButton(
          onTap: () {},
          icon: const Icon(
            Icons.share,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 15),
        CircleButton(
          onTap: () {},
          icon: const Icon(
            Icons.share,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 20),
        CircleButton(
          onTap: () {},
          icon: const Icon(
            Icons.share,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }
}
