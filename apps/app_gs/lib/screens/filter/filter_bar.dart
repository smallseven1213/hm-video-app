// FilterBar is a statefull widget that is used to display the filter bar

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_screen_controller.dart';

import 'option_button.dart';
import 'options.dart';

class FilterBar extends StatefulWidget {
  final ScrollController scrollController;
  const FilterBar({Key? key, required this.scrollController}) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  bool isOpen = false;
  final controller = Get.find<FilterScreenController>();

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
    return FilterOptions();
  }

  Widget _buildClosed() {
    return Container(
      color: const Color(0xFF001A40),
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      height: 40,
      child: GetBuilder<FilterScreenController>(
        builder: (controller) {
          // 生成子元素列錶並添加間距
          List<Widget> childrenWithSpacing = [];
          List<Widget> children = controller.selectedOptions.entries
              .map((entry) => entry.value
                  .where((element) => element != null)
                  .map((value) => OptionButton(
                      isSelected: true,
                      name: controller.findName(entry.key, value)))
                  .toList())
              .expand((element) => element)
              .toList();

          for (int i = 0; i < children.length; i++) {
            childrenWithSpacing.add(children[i]);
            if (i < children.length - 1) {
              childrenWithSpacing.add(const SizedBox(width: 10));
            }
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: childrenWithSpacing,
            ),
          );
        },
      ),
    );
  }
}
