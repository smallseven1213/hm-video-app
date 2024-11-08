import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/utils/handle_url.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/utils/platform_utils.dart';

class FabBanner extends StatelessWidget {
  final BottomNavigatorController bottomNavigatorController =
      Get.find<BottomNavigatorController>();
  FabBanner({super.key});

  bool _hasDepositType(Uri parsedUrl) =>
      parsedUrl.queryParameters.containsKey('depositType');

  bool _hasDefaultScreenKey(Uri parsedUrl) =>
      parsedUrl.queryParameters.containsKey('defaultScreenKey');

  bool _isHttpUrl(String path) =>
      path.startsWith('http://') ||
      path.startsWith('https://') ||
      path.startsWith('*');

  void _hideFab() {
    bottomNavigatorController.changeVisible();
  }

  void handleFabPress(BuildContext context, String path) {
    final parsedUrl = Uri.parse(path);

    if (_isHttpUrl(path)) {
      handleHttpUrl(path);
    } else if (_hasDepositType(parsedUrl)) {
      handleGameDepositType(context, path);
    } else if (_hasDefaultScreenKey(parsedUrl)) {
      handleDefaultScreenKey(context, path);
    } else {
      handlePathWithId(context, path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (bottomNavigatorController.fabLink.isNotEmpty &&
          bottomNavigatorController.isVisible.value &&
          kIsWeb &&
          !isInStandaloneMode()) {
        final fabLinkData = bottomNavigatorController.fabLink.first;
        return Material(
          // 加上 Material widget 確保 InkWell 效果正常顯示
          color: Colors.transparent,
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              children: [
                InkWell(
                  onTap: () => handleFabPress(context, fabLinkData.path ?? ''),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: SidImage(
                      key: ValueKey(fabLinkData.id),
                      sid: fabLinkData.clickEffect!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: _hideFab,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white60,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
