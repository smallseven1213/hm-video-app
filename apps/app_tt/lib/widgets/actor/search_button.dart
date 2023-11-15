import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/svgs/ic-search.svg',
        width: 18,
        height: 18,
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
      ),
      onPressed: () => MyRouteDelegate.of(context).push(AppRoutes.search,
          args: {'inputDefaultValue': '', 'autoSearch': false}),
    );
  }
}
