import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_screen_controller.dart';

import 'option_button.dart';

class FilterOptions extends StatelessWidget {
  FilterOptions({Key? key}) : super(key: key);

  final FilterScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Obx(() => Column(
            children: List.generate(
              controller.menuData.length,
              (index) {
                return Container(
                  height: 30,
                  color: const Color(0xFF001A40),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.menuData[index]['options'].length,
                    itemBuilder: (context, itemIndex) {
                      return Obx(() {
                        final option =
                            controller.menuData[index]['options'][itemIndex];

                        final isSelected = controller
                            .selectedOptions[controller.menuData[index]['key']]!
                            .contains(option['value']);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: OptionButton(
                              isSelected: isSelected,
                              name: option['name'],
                              onTap: () {
                                var key = controller.menuData[index]['key'];
                                controller.handleOptionChange(
                                    key, option['value']);
                              }),
                        );
                      });
                    },
                  ),
                );
              },
            ),
          )),
    );
  }
}
