import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/utils/navigation_helper.dart';

import '../controllers/response_controller.dart';
import '../widgets/error_overlay.dart';
import 'bottom_to_top_page.dart';
import 'no_transition_page.dart';

typedef RouteWidgetBuilder = Widget Function(
    BuildContext, Map<String, dynamic>);

class StackData {
  final String path;
  final Map<String, dynamic> args;
  final bool? hasTransition;
  final bool useBottomToTopAnimation;

  StackData({
    required this.path,
    required this.args,
    this.hasTransition = true,
    this.useBottomToTopAnimation = false,
  });
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
  final responseController = Get.find<ApiResponseErrorCatchController>();

  @override
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  String? get currentConfiguration =>
      _stack.isNotEmpty ? _stack.last.path : null;

  List<String> get stack => List.unmodifiable(_stack);

  void push(String routeName,
      {bool hasTransition = true,
      int deletePreviousCount = 0,
      bool removeSamePath = false,
      bool useBottomToTopAnimation = false, // 添加新参数
      Map<String, dynamic>? args}) {
    if (removeSamePath) {
      _stack.removeWhere((stackData) => stackData.path == routeName);
    }

    _stack.add(StackData(
        path: routeName,
        args: args ?? {},
        hasTransition: hasTransition,
        useBottomToTopAnimation: useBottomToTopAnimation)); // 传递新参数

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
    return Stack(
      children: [
        Navigator(
          key: navigatorKey,
          onPopPage: _onPopPage,
          pages: _stack.map<Page<dynamic>>((stack) {
            // 指定返回的List元素类型
            final widget = routes[stack.path]!(context, stack.args);
            Widget buildScreen() {
              return ErrorOverlayWidget(
                child: widget,
              );
            }

            if (stack.hasTransition == true) {
              return CupertinoPage(
                key: ValueKey(stack.path),
                name: stack.path,
                child: Stack(
                  children: [
                    // widget,
                    buildScreen(),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 8,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.transparent,
                      ),
                    )
                  ],
                ),
                fullscreenDialog: stack.useBottomToTopAnimation,
              );
            }
            if (stack.hasTransition == false) {
              return NoAnimationPage(
                key: ValueKey(stack.path),
                name: stack.path,
                child: buildScreen(),
              );
            }
            return CupertinoPage(
              key: const ValueKey('/'),
              name: '/',
              child: routes['/']!(context, {}),
            );
          }).toList(), // 调用toList时指定类型
        ),
      ],
    );
  }
}
