import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:shared/utils/navigation_helper.dart';

import 'no_transition_page.dart';

typedef RouteWidgetBuilder = Widget Function(
    BuildContext, Map<String, dynamic>);

class StackData {
  final String path;
  final Map<String, dynamic> args;
  final bool? hasTransition;

  StackData(
      {required this.path, required this.args, this.hasTransition = true});
}

final logger = Logger();

class MyRouteDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  final List<StackData> _stack = [StackData(path: '/', args: {})];

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
      bool removeSamePath = false,
      Map<String, dynamic>? args}) {
    if (removeSamePath) {
      _stack.removeWhere((stackData) => stackData.path == routeName);
    }

    _stack.add(StackData(
        path: routeName, args: args ?? {}, hasTransition: hasTransition));

    if (deletePreviousCount > 0) {
      _stack.removeRange(
          _stack.length - deletePreviousCount - 1, _stack.length - 1);
    }
    logger.i(_stack);
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
    _stack.add(StackData(
        path: newRoute, args: args ?? {}, hasTransition: hasTransition));
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
        if (stack.hasTransition == true) {
          return CupertinoPage(
            key: ValueKey(stack.path),
            name: stack.path,
            child: routes[stack.path]!(context, stack.args),
          );
        }
        if (stack.hasTransition == false) {
          return NoAnimationPage(
            key: ValueKey(stack.path),
            name: stack.path,
            child: routes[stack.path]!(context, stack.args),
          );
        }
        return CupertinoPage(
          key: const ValueKey('/'),
          name: '/',
          child: routes['/']!(context, stack.args),
        );
      }).toList(),
    );
  }
}
