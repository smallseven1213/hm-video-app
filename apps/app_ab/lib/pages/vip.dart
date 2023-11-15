import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared/controllers/bottom_navigator_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import '../widgets/custom_app_bar.dart';

class VipPage extends StatelessWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomNavigatorController = Get.find<BottomNavigatorController>();

    return Scaffold(
        appBar: const CustomAppBar(title: 'VIP'),
        body: Stack(
          children: [
            Center(
              child: Image(
                image: const AssetImage('assets/images/vip/ab_vip_01.jpg'),
                height: MediaQuery.sizeOf(context).height,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: InkWell(
                  onTap: () {
                    MyRouteDelegate.of(context).pushAndRemoveUntil(
                      AppRoutes.home,
                      args: {'defaultScreenKey': '/game'},
                    );
                    bottomNavigatorController.changeKey('/game');
                  },
                  child: Image(
                    image: const AssetImage('assets/images/vip/ab_vip_02.png'),
                    width: MediaQuery.sizeOf(context).width * 0.65,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
