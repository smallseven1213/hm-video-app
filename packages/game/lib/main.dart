// game_package/lib/navigator.dart
import 'package:flutter/material.dart';

import 'routes/game_routes.dart';

class GameNavigator extends StatefulWidget {
  final List<String> initialPath;
  final Map<String, dynamic> arguments;

  const GameNavigator(
      {super.key,
      required this.initialPath,
      this.arguments = const {}}); // Use 'required' instead of '@required'

  @override
  GameNavigatorState createState() => GameNavigatorState();
}

class GameNavigatorState extends State<GameNavigator> {
  late List<String> path; // Use 'late' here

  @override
  void initState() {
    super.initState();
    path = widget.initialPath;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: path.expand<Page>((routeName) {
        if (gameRoutes.containsKey(routeName)) {
          return [
            MaterialPage(
              key: ValueKey(routeName),
              child: gameRoutes[routeName]!(context, widget.arguments),
            )
          ];
        }
        return [];
      }).toList(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        path.removeLast();
        return true;
      },
    );
  }
}
