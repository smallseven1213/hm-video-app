import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("clicked!");
      },
      child: Container(
        width: 31,
        height: 31,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.3),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            'svgs/ic-changepassword.svg',
            width: 17,
            height: 17,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
