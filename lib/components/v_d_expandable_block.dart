import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';

class VDExpandableBlock extends StatefulWidget {
  final int recursiveCount;
  final Widget header;
  final Widget body;
  final bool searchable;
  final bool expandable;
  final bool defaultExpandable;
  final bool tags; // 多選
  final List<int> _selectedIds;

  VDExpandableBlock({
    Key? key,
    required this.header,
    required this.body,
    this.expandable = true,
    this.defaultExpandable = false,
    this.searchable = false,
    this.tags = false,
    this.recursiveCount = 5,
    List<int>? selectedIds,
  })  : _selectedIds = selectedIds ?? [],
        super(key: key);

  @override
  _VDExpandableBlockState createState() => _VDExpandableBlockState();
}

class _VDExpandableBlockState extends State<VDExpandableBlock> {
  bool isSelected = false;
  bool isExpanded = false;
  String keyword = '';

  @override
  void initState() {
    isExpanded = widget.defaultExpandable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: gs().width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VDIcon(isExpanded ? VIcons.arrow_2_down : VIcons.arrow_2_right),
                Expanded(
                  flex: 2,
                  child: widget.header,
                ),
              ],
            ),
          ),
          const Divider(),
          ...(!widget.expandable || isExpanded ? [widget.body] : []),
        ],
      ),
    );
  }
}
