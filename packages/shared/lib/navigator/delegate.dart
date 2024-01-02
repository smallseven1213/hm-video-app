import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/main.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared/utils/navigation_helper.dart';
import 'package:uuid/uuid.dart';

import '../controllers/response_controller.dart';
import '../widgets/error_overlay.dart';
import 'my_navigator_observer.dart';
import 'no_transition_page.dart';

typedef RouteWidgetBuilder = Widget Function(
    BuildContext, Map<String, dynamic>);

class StackData {
  final String path;
  final Map<String, dynamic> args;
  final bool? hasTransition;
  final bool useBottomToTopAnimation;
  final Completer<void> completer;

  StackData({
    required this.path,
    required this.args,
    required this.completer,
    this.hasTransition = true,
    this.useBottomToTopAnimation = false,
  });
}

class MyRouteDelegate extends RouterDelegate<String>
    with PopNavigatorRouterDelegateMixin<String>, ChangeNotifier {
  final List<StackData> _stack = [
    StackData(path: '/', args: {}, completer: Completer<void>())
  ];

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

  Future<void> push(String routeName,
      {bool hasTransition = true,
      int deletePreviousCount = 0,
      bool removeSamePath = false,
      bool useBottomToTopAnimation = false,
      Map<String, dynamic>? args}) {
    final Completer<void> completer = Completer<void>();

    if (removeSamePath) {
      _stack.removeWhere((stackData) => stackData.path == routeName);
    }

    Map<String, dynamic> nextArgs = args ?? {};
    final uuid = const Uuid().v4();
    nextArgs = {
      ...args ?? {},
      'uuid': uuid,
    };

    _stack.add(StackData(
      path: routeName,
      args: nextArgs,
      hasTransition: hasTransition,
      useBottomToTopAnimation: useBottomToTopAnimation, // 传递新参数
      completer: completer, // Pass the completer to your stack data
    ));

    if (deletePreviousCount > 0) {
      _stack.removeRange(
          _stack.length - deletePreviousCount - 1, _stack.length - 1);
    }
    notifyListeners();

    return completer.future; // Return the future of the completer
  }

  void remove(String routeName) {
    _stack.removeWhere((stackData) => stackData.path == routeName);
    notifyListeners();
  }

  void pushAndRemoveUntil(String newRoute,
      {bool hasTransition = true, Map<String, dynamic>? args}) {
    _stack.clear();
    // var uuid = const Uuid().v4();
    _stack.add(StackData(
      path: newRoute,
      args: {
        ...args ?? {},
        // 'uuid': uuid,
      },
      hasTransition: hasTransition,
      completer: Completer<void>(), // Add this line
    ));
    notifyListeners();
  }

  @override
  Future<void> setInitialRoutePath(String configuration) {
    return setNewRoutePath(configuration);
  }

  void pop() {
    if (_stack.isNotEmpty) {
      final lastStackData = _stack.removeLast();
      lastStackData.completer.complete();
      notifyListeners();
    }
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    // var uuid = const Uuid().v4();
    _stack
      ..clear()
      ..add(StackData(
        path: configuration,
        // args: {'uuid': uuid},
        args: {},
        completer: Completer<void>(),
      ));
    return SynchronousFuture<void>(null);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (_stack.isNotEmpty) {
      if (_stack.last.path == route.settings.name) {
        final lastStackData = _stack.removeLast();
        lastStackData.completer.complete();
        notifyListeners();
      }
    }
    return route.didPop(result);
  }

  @override
  Widget build(BuildContext context) {
    print("MyRouteDelegate _stack $homePath > $_stack");
    return Stack(
      children: [
        Navigator(
          key: navigatorKey,
          observers: [
            MyNavigatorObserver(),
            SentryNavigatorObserver(),
          ],
          onPopPage: _onPopPage,
          pages: _stack.map<Page<dynamic>>((stack) {
            try {
              final widget = routes[stack.path]!(context, stack.args);

              if (stack.hasTransition == true) {
                return CupertinoPage(
                  // key is a new Global key
                  key: ValueKey(stack.path + stack.args.toString()),
                  // key: ValueKey(stack.args['uuid']),
                  maintainState: false,
                  name: stack.path,
                  child: Stack(
                    children: [
                      ErrorOverlayWidget(
                        child: widget,
                      ),
                      const TestWidget(),
                      Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                              width: 16,
                              height: MediaQuery.of(context).size.height,
                              color: Colors.transparent))
                    ],
                  ),
                  fullscreenDialog: stack.useBottomToTopAnimation,
                );
              }
              if (stack.hasTransition == false) {
                return NoAnimationPage(
                  key: ValueKey(stack.path + stack.args.toString()),
                  name: stack.path,
                  child: ErrorOverlayWidget(
                    child: widget,
                  ),
                );
              }
              return CupertinoPage(
                key: const ValueKey('/'),
                name: '/',
                child: routes['/']!(context, {}),
              );
            } catch (e, stackTrace) {
              print('MyRouteDelegate build error: $e');
              print('MyRouteDelegate build error: $stackTrace');
              return CupertinoPage(
                key: const ValueKey('/'),
                name: '/',
                child: routes['/']!(context, {}),
              );
            }
          }).toList(),
        ),
      ],
    );
  }
}

// TestWidget statelss widget, empty container
class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
