import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class VDExpandableItem {
  final int id;
  final String name;
  bool selected = false;
  VDExpandableItem({
    required this.id,
    required this.name,
  });
}

typedef VDSearchExpandItems = Future<List<VDExpandableItem>> Function(String);

class VDExpandablePanel extends StatefulWidget {
  final int recursiveCount;
  final String title;
  final ValueChanged<List<int>> onSelected;
  final bool searchable;
  final bool expandable;
  final bool defaultExpandable;
  final bool tags; // 多選
  final List<int> _selectedIds;
  final VDSearchExpandItems request;

  VDExpandablePanel({
    Key? key,
    required this.title,
    required this.onSelected,
    this.expandable = true,
    this.defaultExpandable = false,
    this.searchable = false,
    this.tags = false,
    required this.request,
    this.recursiveCount = 5,
    List<int>? selectedIds,
  })  : _selectedIds = selectedIds ?? [],
        super(key: key);

  @override
  _VDExpandablePanelState createState() => _VDExpandablePanelState();
}

class _VDExpandablePanelState extends State<VDExpandablePanel> {
  bool isSelected = false;
  bool isExpanded = false;
  // List<VDExpandableItem> optionsSelected = [];
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
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            enableFeedback: true,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 0,
                right: 0,
                top: 15,
                bottom: 3,
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 1,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                          ),
                          Container(
                            width: 4,
                            height: 10,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: const BoxDecoration(
                              color: color1,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          SizedBox(
                            height: 20,
                            child: Text(widget.title),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          !widget.expandable
                              ? const SizedBox.shrink()
                              : VDIcon(
                                  isSelected ? VIcons.check_green : VIcons.plus,
                                  width: 12,
                                ),
                          Container(
                            width: 8,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          ...(!widget.expandable || isExpanded
              ? [
                  ...(widget.searchable
                      ? [
                          Container(
                            height: 40,
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 5,
                              bottom: 5,
                            ),
                            child: TextFormField(
                              style: const TextStyle(
                                  // backgroundColor: Colors.white,
                                  ),
                              maxLength: 6,
                              // autofocus: true,
                              onChanged: (val) {
                                setState(() {
                                  keyword = val;
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                counterText: "",
                                contentPadding: const EdgeInsets.only(left: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                // hintText: '輸入番號、女優名或...',
                                hintText: '輸入名稱',
                                hintStyle: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromRGBO(167, 167, 167, 1),
                                ),
                                focusColor: Colors.white,
                              ),
                            ),
                          ),
                        ]
                      : []),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 0,
                        bottom: 5,
                      ),
                      child: FutureBuilder<List<VDExpandableItem>>(
                        future: widget.request(keyword),
                        builder: (_ctx, _snapshot) {
                          int i = 0;
                          List<VDExpandableItem> items = [];
                          List<List<VDExpandableItem>> recursiveItems = [[]];
                          if (_snapshot.hasData) {
                            items = (_snapshot.data ?? []).map((e) {
                              e.selected = widget._selectedIds.contains(e.id);
                              return e;
                            }).toList();
                            for (var item in items) {
                              if (recursiveItems[i].length >=
                                  widget.recursiveCount) {
                                i++;
                                recursiveItems.add([]);
                              }
                              recursiveItems[i].add(item);
                            }
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: recursiveItems
                                .map((e) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: e
                                          .map((ec) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    var copy = [
                                                      ...widget._selectedIds,
                                                    ];
                                                    if (widget.tags) {
                                                      if (!widget._selectedIds
                                                          .contains(ec.id)) {
                                                        copy.add(ec.id);
                                                      } else {
                                                        copy.removeWhere(
                                                            (element) =>
                                                                element ==
                                                                ec.id);
                                                      }
                                                    } else {
                                                      copy = [ec.id];
                                                    }

                                                    widget.onSelected(copy);
                                                    isSelected =
                                                        copy.isNotEmpty;
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                    top: 5,
                                                    bottom: 5,
                                                    left: 4,
                                                    right: 4,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                    top: 4,
                                                    bottom: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: ec.selected
                                                        ? color3
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                      color: color7,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                  ),
                                                  child: Text('${ec.name}'),
                                                ),
                                              ))
                                          .toList(),
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ),
                  )
                ]
              : []),
        ],
      ),
    );
  }
}
