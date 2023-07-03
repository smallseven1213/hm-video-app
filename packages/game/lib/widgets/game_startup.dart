import 'package:get/get.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

class GameStartupController extends GetxController {
  void goBackToAppHome(context) {
    MyRouteDelegate.of(context).push(
      AppRoutes.home.value,
      hasTransition: false,
      removeSamePath: true,
      args: {'defaultScreenKey': '/game'},
    );
  }
}
