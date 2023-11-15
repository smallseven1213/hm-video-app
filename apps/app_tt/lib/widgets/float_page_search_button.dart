import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

class FloatPageSearchButton extends StatelessWidget {
  const FloatPageSearchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Navigator.canPop(context)) {
      return Positioned(
        top: 0,
        right: 8,
        child: GestureDetector(
          onTap: () {
            MyRouteDelegate.of(context).push(AppRoutes.search,
                args: {'inputDefaultValue': '', 'autoSearch': false});
          },
          child: Container(
            width: 31, // width of the AppBar's leading area
            height: 31, // height of the AppBar's leading area
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svgs/ic-search.svg',
                width: 17,
                height: 17,
                color: Colors.white,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
