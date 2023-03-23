import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared/utils/navigation_helper.dart';

typedef RouteWidgetBuilder = Widget Function(
    BuildContext, Map<String, dynamic>);

class StackData {
  final String path;
  final Map<String, dynamic> args;

  StackData({required this.path, required this.args});
}

final logger = Logger();

class MyRouteDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  // final List<String> _stack = ['/'];
  // convert _stack type to List<StackData>
  // StackData have path String and args Map<String, dynamic>
  final List<StackData> _stack = [StackData(path: '/', args: {})];
  bool _hasTransition = true;

  static MyRouteDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is MyRouteDelegate, 'Delegate type must match');
    return delegate as MyRouteDelegate;
  }

  MyRouteDelegate({
    required this.routes,
    required this.homePath,
    this.onGenerateRoute,
  }) {
    setNavigatorKey(navigatorKey);
  }

  final RouteFactory? onGenerateRoute;
  final Map<String, RouteWidgetBuilder> routes;
  final String homePath;

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  String? get currentConfiguration =>
      _stack.isNotEmpty ? _stack.last.path : null;

  List<String> get stack => List.unmodifiable(_stack);

  // void push, from newRoute and add to _stack
  void push(String routeName,
      {bool hasTransition = true,
      int deletePreviousCount = 0,
      Map<String, dynamic>? args}) {
    _stack.add(StackData(path: routeName, args: args ?? {}));
    if (deletePreviousCount > 0) {
      _stack.removeRange(
          _stack.length - deletePreviousCount - 1, _stack.length - 1);
    }
    _hasTransition = hasTransition;
    notifyListeners();
  }

  void remove(String routeName) {
    _stack.remove(routeName);
    notifyListeners();
  }

  // implement pushAndRemoveUntil
  void pushAndRemoveUntil(String newRoute,
      {bool hasTransition = true, Map<String, dynamic>? args}) {
    _stack.clear();
    _stack.add(StackData(path: newRoute, args: args ?? {}));
    _hasTransition = hasTransition;
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
      ..add(StackData(path: configuration, args: {}));
    return SynchronousFuture<void>(null);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (_stack.isNotEmpty) {
      logger.i(route.settings.name);
      if (_stack.last.path == route.settings.name) {
        _stack.removeLast();
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
      pages: _stack.map((stack) {
        if (routes[stack.path] == null) {
          return MaterialPage(
            key: const ValueKey('/'),
            name: '/',
            child: routes['/']!(context, stack.args),
          );
        }
        if (_hasTransition) {
          return MaterialPage(
            key: ValueKey(stack.path),
            name: stack.path,
            child: routes[stack.path]!(context, stack.args),
          );
        }
        return NoTransitionPage(
            child: routes[stack.path]!(context, stack.args));
      }).toList(),
    );
  }
}
