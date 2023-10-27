import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search, color: Colors.black, size: 18),
      onPressed: () => MyRouteDelegate.of(context).push(AppRoutes.search,
          args: {'inputDefaultValue': '', 'autoSearch': false}),
    );
  }
}
