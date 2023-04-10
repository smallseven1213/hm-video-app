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
      padding: const EdgeInsets.symmetric(vertical: 8),
      sliver: Obx(() => SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.menuData[index]['options'].length,
                    itemBuilder: (context, itemIndex) {
                      final option =
                          controller.menuData[index]['options'][itemIndex];
                      final isSelected = controller
                          .selectedOptions[controller.menuData[index]['key']]!
                          .contains(option['value']);
                      return OptionButton(
                        option: option,
                        isSelected: isSelected,
                        onTap: () {
                          controller.handleOptionChange(
                              controller.menuData[index]['key'],
                              option['value']);
                        },
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
