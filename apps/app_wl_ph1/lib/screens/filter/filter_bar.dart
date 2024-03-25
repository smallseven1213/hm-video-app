import 'package:app_wl_ph1/localization/i18n.dart';
// FilterBar is a statefull widget that is used to display the filter bar

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_screen_controller.dart';

import 'option_button.dart';
import 'options.dart';

class FilterBar extends StatefulWidget {
  final RxList<Map<String, dynamic>> menuData;
  final RxMap<String, Set> selectedOptions;
  final void Function(String key, dynamic value) handleOptionChange;
  final int film;
  const FilterBar({
    Key? key,
    required this.menuData,
    required this.selectedOptions,
    required this.handleOptionChange,
    required this.film,
  }) : super(key: key);

  @override
  FilterBarState createState() => FilterBarState();
}

class FilterBarState extends State<FilterBar> {
  final filterScreenController = Get.find<FilterScreenController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return GestureDetector(
          onTap: () {
            filterScreenController.handleOption(
                showTab: true, openOption: true);
          },
          child: filterScreenController.selectedBarOpen.value
              ? _buildOpen()
              : _buildClosed(),
        );
      },
    );
  }

  Widget _buildOpen() {
    return Container(
      color: const Color(0xFF001A40),
      // padding: const EdgeInsets.all(8),
      // color: Colors.red,
      width: double.infinity,
      height: 130,
      child: FilterOptions(
        menuData: widget.menuData,
        selectedOptions: widget.selectedOptions,
        handleOptionChange: widget.handleOptionChange,
      ),
    );
  }

  String findName(String key, int value) {
    // find name from menuData by key and value, return name
    var options =
        widget.menuData.firstWhere((item) => item['key'] == key)['options'];
    var name = options.firstWhere((item) => item['value'] == value)['name'];
    return name;
  }

  Widget _buildClosed() {
    List<Widget> childrenWithSpacing = [
      OptionButton(
          isSelected: true,
          name: widget.film == 1 ? I18n.longVideo : I18n.shortVideo),
      const SizedBox(width: 10),
    ];
    List<Widget> children = widget.selectedOptions.entries
        .map((entry) => entry.value
            .where((element) => element != null)
            .map((value) => OptionButton(
                isSelected: true, name: findName(entry.key, value)))
            .toList())
        .expand((element) => element)
        .toList();

    for (int i = 0; i < children.length; i++) {
      childrenWithSpacing.add(children[i]);
      if (i < children.length - 1) {
        childrenWithSpacing.add(const SizedBox(width: 10));
      }
    }

    return Container(
      color: const Color(0xFF001A40),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      height: 46,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: childrenWithSpacing,
        ),
      ),
    );
  }
}
