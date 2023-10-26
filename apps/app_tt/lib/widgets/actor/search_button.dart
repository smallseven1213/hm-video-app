import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
        'svgs/ic-search.svg',
        width: 17,
        height: 17,
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
      ),
      onPressed: () => MyRouteDelegate.of(context).push(AppRoutes.search,
          args: {'inputDefaultValue': '', 'autoSearch': false}),
    );
  }
}
