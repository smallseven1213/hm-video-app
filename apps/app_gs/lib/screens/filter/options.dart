import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_video_screen_controller.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Obx(() {
        logger.i('menuData => $menuData');
        return Column(
          children: List.generate(
            menuData.length,
            (index) {
              return Container(
                height: 20,
                color: const Color(0xFF001A40),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: menuData[index]['options'].length,
                  itemBuilder: (context, itemIndex) {
                    return Obx(() {
                      final option = menuData[index]['options'][itemIndex];

                      final isSelected =
                          selectedOptions[menuData[index]['key']]!
                              .contains(option['value']);

                      return Padding(
                        padding: const EdgeInsets.all(2),
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
      }),
    );
  }
}
