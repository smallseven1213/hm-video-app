import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyRouteDelegate.of(context).push(AppRoutes.search,
            args: {'inputDefaultValue': '', 'autoSearch': false});
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
            'assets/svgs/ic-search.svg',
            width: 17,
            height: 17,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
