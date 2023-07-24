import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

class FloatPageBackButton extends StatelessWidget {
  final Map? floatBackRoute;
  const FloatPageBackButton({Key? key, this.floatBackRoute}) : super(key: key);

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
              if (floatBackRoute != null) {
                MyRouteDelegate.of(context).push(floatBackRoute!['path'],
                    args: floatBackRoute!['args']);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
