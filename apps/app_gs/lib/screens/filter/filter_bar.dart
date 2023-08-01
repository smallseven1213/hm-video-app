// FilterBar is a statefull widget that is used to display the filter bar

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_screen_controller.dart';

import 'option_button.dart';
import 'options.dart';

class FilterBar extends StatefulWidget {
  final ScrollController scrollController;
  final RxList<Map<String, dynamic>> menuData;
  final RxMap<String, Set> selectedOptions;
  final void Function(String key, dynamic value) handleOptionChange;

  const FilterBar({
    Key? key,
    required this.scrollController,
    required this.menuData,
    required this.selectedOptions,
    required this.handleOptionChange,
  }) : super(key: key);

  @override
  FilterBarState createState() => FilterBarState();
}

class FilterBarState extends State<FilterBar> {
  bool isOpen = false;
  // final controller = Get.find<FilterScreenController>();

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (widget.scrollController.position.userScrollDirection !=
        ScrollDirection.idle) {
      if (mounted) {
        setState(() {
          isOpen = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            isOpen = true;
          });
        },
        child: isOpen ? _buildOpen() : _buildClosed());
  }

  Widget _buildOpen() {
    return FilterOptions(
      menuData: widget.menuData,
      selectedOptions: widget.selectedOptions,
      handleOptionChange: widget.handleOptionChange,
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
    List<Widget> childrenWithSpacing = [];
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
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: childrenWithSpacing,
        ),
      ),
    );
  }
}
