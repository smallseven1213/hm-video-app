import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_page_controller.dart';

class OpenDrawerButton extends StatelessWidget {
  const OpenDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
        builder: (controller) => GestureDetector(
              onTap: () {
                controller.toggleDrawer();
              },
              child: Container(
                width: 31,
                height: 31,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  // child is SVG Icon by flutter_svg plugin
                  child: SvgPicture.asset(
                    'assets/svgs/ic-filter.svg',
                    width: 14,
                    height: 14,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  // child: Icon(
                  //   Icons.search,
                  //   size: 14,
                  //   color: Colors.white,
                  // ),
                ),
              ),
            ));
  }
}
