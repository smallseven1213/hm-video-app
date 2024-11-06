import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/utils/handle_url.dart';

import '../../widgets/custom_app_bar.dart';
import '../apps_screen/index.dart';

class HomeAppsScreen extends StatefulWidget {
  const HomeAppsScreen({Key? key}) : super(key: key);

  @override
  HomeAppsScreenState createState() => HomeAppsScreenState();
}

class HomeAppsScreenState extends State<HomeAppsScreen> {
  late BottomNavigatorController bottomNavigatorController;
  Navigation? _topFabLinkData;

  @override
  void initState() {
    super.initState();
    bottomNavigatorController = Get.find<BottomNavigatorController>();
    if (bottomNavigatorController.fabLink.isNotEmpty) {
      _topFabLinkData = bottomNavigatorController.fabLink[0];
    }
  }

  void _hideFab() {
    bottomNavigatorController.changeVisible();
  }

  void _handleFabPress(String path) {
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

  bool _hasDepositType(Uri parsedUrl) =>
      parsedUrl.queryParameters.containsKey('depositType');

  bool _hasDefaultScreenKey(Uri parsedUrl) =>
      parsedUrl.queryParameters.containsKey('defaultScreenKey');

  bool _isHttpUrl(String path) =>
      path.startsWith('http://') ||
      path.startsWith('https://') ||
      path.startsWith('*');

  @override
  void dispose() {
    bottomNavigatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // HC: 煩死，勿動!!
      child: Scaffold(
        appBar: CustomAppBar(
          leadingWidth: 0,
          leadingWidget: Container(),
          titleWidget: Obx(() {
            return bottomNavigatorController.isVisible.value
                ? InkWell(
                    onTap: () => _handleFabPress(_topFabLinkData!.path!),
                    child: SizedBox(
                      height: 56,
                      child: Stack(
                        children: [
                          SizedBox.expand(
                            child: SidImage(
                              key: ValueKey(_topFabLinkData!.id),
                              sid: _topFabLinkData!.clickEffect!,
                              fit: BoxFit.cover,
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
                          ),
                        ],
                      ),
                    ),
                  )
                : Text(
                    bottomNavigatorController.activeTitle.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  );
          }),
        ),
        body: const AppsScreen(),
      ),
    );
  }
}
