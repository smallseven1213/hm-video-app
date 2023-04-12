import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_screen_controller.dart';

import 'option_button.dart';

class FilterOptions extends StatelessWidget {
  FilterOptions({Key? key}) : super(key: key);

  final FilterScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      sliver: Obx(() => SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.menuData[index]['options'].length,
                    itemBuilder: (context, itemIndex) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: OptionButton(index: index, itemIndex: itemIndex),
                      );
                    },
                  ),
                );
              },
              childCount: controller.menuData.length,
            ),
          )),
    );
  }
}
