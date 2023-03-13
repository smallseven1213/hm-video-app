import 'package:flutter/widgets.dart';

class NoTransitionPage extends Page {
  final Widget child;

  NoTransitionPage({required this.child}) : super(key: ValueKey(child));

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      pageBuilder: (context, _, __) => child,
      transitionsBuilder: (_, __, ___, child) => child,
    );
  }
}
