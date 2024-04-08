import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';

void gotoDeposit() {
  final bottomNavigatorController = Get.find<BottomNavigatorController>();
  /**
   * if (mounted &&
        Get.find<UIController>().tempData.value == 'goto_deposit_after_login') {
      Get.find<UIController>().clearTempData();
      MyRouteDelegate.of(context).push(
        GameAppRoutes.depositList,
      );
    }
   */
  bottomNavigatorController.changeKey("/game");
}
