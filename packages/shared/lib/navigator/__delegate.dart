import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/utils/navigation_helper.dart';

import 'fade_in_page.dart';
import 'no_transition_page.dart';

typedef RouteWidgetBuilder = Widget Function(
    BuildContext, Map<String, dynamic>);

class StackData {
  final String path;
  final Map<String, dynamic> args;
  final bool? hasTransition;
  final bool? hasFadeEffect;

  StackData(
      {required this.path,
      required this.args,
      this.hasTransition = true,
      this.hasFadeEffect = false});
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

  void push(String routeName,
      {bool hasTransition = true,
      bool hasFadeEffect = false,
      int deletePreviousCount = 0,
      Map<String, dynamic>? args}) {
    _stack.add(StackData(
        path: routeName,
        args: args ?? {},
        hasTransition: hasTransition,
        hasFadeEffect: hasFadeEffect));
    if (deletePreviousCount > 0) {
      _stack.removeRange(
          _stack.length - deletePreviousCount - 1, _stack.length - 1);
    }
    notifyListeners();
  }

  void pushAndRemoveUntil(String newRoute,
      {bool hasTransition = true,
      bool hasFadeEffect = false,
      Map<String, dynamic>? args}) {
    _stack.clear();
    _stack.add(StackData(
        path: newRoute,
        args: args ?? {},
        hasTransition: hasTransition,
        hasFadeEffect: hasFadeEffect));
    notifyListeners();
  }

  void remove(String routeName) {
    _stack.remove(routeName);
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
      pages: _stack.map<Page<dynamic>>((stack) {
        // Case 1: hasTransition == true, hasFadeEffect == true
        if (stack.hasTransition == true && stack.hasFadeEffect == true) {
          return FadeInPage(
            key: ValueKey(stack.path),
            name: stack.path,
            child: routes[stack.path]!(context, stack.args),
          );
        }

        // Case 2: hasTransition == false, hasFadeEffect == true
        if (stack.hasTransition == false && stack.hasFadeEffect == true) {
          return NoAnimationPage(
            key: ValueKey(stack.path),
            name: stack.path,
            child: routes[stack.path]!(context, stack.args),
          );
        }

        // Case 3: hasTransition == true, hasFadeEffect == false
        if (stack.hasTransition == true && stack.hasFadeEffect == false) {
          return MaterialPage(
            key: ValueKey(stack.path),
            name: stack.path,
            child: routes[stack.path]!(context, stack.args),
          );
        }

        // Default case: '/' route
        return MaterialPage(
          key: const ValueKey('/'),
          name: '/',
          child: routes['/']!(context, stack.args),
        );
      }).toList(),
    );
  }
}
