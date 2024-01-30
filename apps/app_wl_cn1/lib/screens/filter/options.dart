import 'package:app_wl_cn1/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_video_screen_controller.dart';
import 'package:shared/models/color_keys.dart';

import 'option_button.dart';

class FilterOptions extends StatelessWidget {
  final RxList<Map<String, dynamic>> menuData;
  final RxMap<String, Set> selectedOptions;
  final void Function(String key, dynamic value) handleOptionChange;

  FilterOptions({
    Key? key,
    required this.menuData,
    required this.selectedOptions,
    required this.handleOptionChange,
  }) : super(key: key);

  final FilterVideoScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: List.generate(
          menuData.length,
          (index) {
            return Container(
              height: 35,
              color: AppColors.colors[ColorKeys.background],
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: menuData[index]['options'].length,
                itemBuilder: (context, itemIndex) {
                  return Obx(() {
                    final option = menuData[index]['options'][itemIndex];

                    final isSelected = selectedOptions[menuData[index]['key']]!
                        .contains(option['value']);

                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: OptionButton(
                          isSelected: isSelected,
                          name: option['name'],
                          onTap: () {
                            var key = menuData[index]['key'];
                            handleOptionChange(key, option['value']);
                          }),
                    );
                  });
                },
              ),
            );
          },
        ),
      );
    });
  }
}
