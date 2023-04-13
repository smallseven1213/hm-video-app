import 'package:flutter/widgets.dart';

class FadeInPage extends Page {
  final Widget child;
  final String name;

  const FadeInPage({
    required this.child,
    required this.name,
    LocalKey? key,
  }) : super(key: key, name: name);

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
