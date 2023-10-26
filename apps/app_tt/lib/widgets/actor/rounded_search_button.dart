import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

class RoundedSearchButton extends StatelessWidget {
  const RoundedSearchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      right: 16,
      child: GestureDetector(
        onTap: () => MyRouteDelegate.of(context).push(AppRoutes.search,
            args: {'inputDefaultValue': '', 'autoSearch': false}),
        child: Container(
          width: 31,
          height: 31,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              'svgs/ic-search.svg',
              width: 17,
              height: 17,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
