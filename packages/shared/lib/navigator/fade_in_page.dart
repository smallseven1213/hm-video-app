import 'package:flutter/widgets.dart';

class FadeInPage extends Page {
  final Widget child;

  const FadeInPage({
    required this.child,
    LocalKey? key,
  }) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
