import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyRouteDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  final List<String> _stack = ['/'];

  static MyRouteDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is MyRouteDelegate, 'Delegate type must match');
    return delegate as MyRouteDelegate;
  }

  MyRouteDelegate({
    required this.routes,
    required this.homePath,
    this.onGenerateRoute,
  });

  final RouteFactory? onGenerateRoute;
  final Map<String, WidgetBuilder> routes;
  final String homePath;

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  // type Page currentConfiguration is the last element of _stack
  String? get currentConfiguration => _stack.isNotEmpty ? _stack.last : null;
  // Page? get currentConfiguration => _stack.isNotEmpty ? _stack.last : null;

  List<String> get stack => List.unmodifiable(_stack);

  // void push, from newRoute and add to _stack
  void push(String routeName) {
    _stack.add(routeName);
    notifyListeners();
  }

  void remove(String routeName) {
    _stack.remove(routeName);
    notifyListeners();
  }

  // implement pushAndRemoveUntil
  void pushAndRemoveUntil(String newRoute) {
    _stack.clear();
    _stack.add(newRoute);
    notifyListeners();
  }

  @override
  Future<void> setInitialRoutePath(String configuration) {
    return setNewRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    _stack
      ..clear()
      ..add(configuration);
    return SynchronousFuture<void>(null);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (_stack.isNotEmpty) {
      if (_stack.last == route.settings.name) {
        _stack.remove(route.settings.name);
        notifyListeners();
      }
    }
    return route.didPop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: _stack.map((name) {
        return MaterialPage(
          key: ValueKey(name),
          name: name,
          child: routes[name]!(context),
        );
      }).toList(),
    );
  }
}
