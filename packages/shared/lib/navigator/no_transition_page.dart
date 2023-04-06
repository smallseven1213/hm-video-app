import 'package:flutter/widgets.dart';

class NoAnimationPage extends Page<dynamic> {
  final Widget child;

  const NoAnimationPage({
    required this.child,
    required String name,
    LocalKey? key,
  }) : super(key: key, name: name);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, __, ___, Widget child) => child,
    );
  }
}
