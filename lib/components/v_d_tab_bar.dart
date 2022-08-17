import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/v_tab_collection.dart';
import 'package:wgp_video_h5app/styles.dart';

class VDTabBar<T> extends StatefulWidget {
  final VTabCollection tabs;
  final int type;
  final int index;
  final TabController? tabController;
  const VDTabBar({
    Key? key,
    required this.tabs,
    this.type = 1,
    this.tabController,
    this.index = 0,
  }) : super(key: key);

  @override
  _VDTabBarState<T> createState() => _VDTabBarState<T>();
}

class _VDTabBarState<T> extends State<VDTabBar<T>>
    with SingleTickerProviderStateMixin {
  late VTabCollection tabs;

  @override
  void initState() {
    super.initState();
    tabs = widget.tabs;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
    switch (widget.type) {
      case 2:
        labelStyle = const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        );
        return TabBar(
          controller: widget.tabController,
          physics: const BouncingScrollPhysics(),
          indicator: const BoxDecoration(
            color: mainBgColor,
          ),
          indicatorColor: mainBgColor,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
          labelPadding: EdgeInsets.zero,
          tabs: tabs
              .getTabs()
              .map((key, value) => MapEntry(
                    key,
                    key + 1 == tabs.getTabs().length
                        ? Tab(
                            child: Text(
                              value.name,
                              style: labelStyle,
                            ),
                          )
                        : SizedBox(
                            height: 23,
                            child: Tab(
                              child: Text(
                                value.name,
                                style: labelStyle,
                              ),
                            ),
                          ),
                  ))
              .values
              .toList(),
        );

      case 3:
        return TabBar(
          controller: widget.tabController,
          physics: const BouncingScrollPhysics(),
          indicator: const BoxDecoration(
            color: mainBgColor,
          ),
          indicatorColor: mainBgColor,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
          labelPadding: EdgeInsets.zero,
          tabs: tabs
              .getTabs()
              .map((key, value) => MapEntry(
                    key,
                    key + 1 == tabs.getTabs().length
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            child: Tab(
                              child: Text(
                                value.name,
                                style: labelStyle,
                              ),
                            ),
                          )
                        : Container(
                            height: 23,
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Color.fromRGBO(219, 219, 219, 1),
                                ),
                              ),
                            ),
                            child: Tab(
                              child: Text(
                                value.name,
                                style: labelStyle,
                              ),
                            ),
                          ),
                  ))
              .values
              .toList(),
        );

      case 1:
      default:
        return TabBar(
          controller: widget.tabController,
          isScrollable: true,
          enableFeedback: true,
          physics: const BouncingScrollPhysics(),
          indicator: const UnderlineTabIndicator(
            insets: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            borderSide: BorderSide(
              width: 3.0,
              color: Colors.black,
            ),
          ),
          // indicatorColor: color1,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
          labelPadding: EdgeInsets.zero,
          tabs: tabs
              .getTabs()
              .map((key, value) => MapEntry(
                    key,
                    key + 1 == tabs.getTabs().length
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            child: Tab(
                              child: Text(
                                value.name,
                                style: widget.tabController?.index == key
                                    ? const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )
                                    : labelStyle,
                              ),
                            ),
                          )
                        : Container(
                            height: 23,
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            child: Tab(
                              child: Text(
                                value.name,
                                style: widget.tabController?.index == key
                                    ? const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )
                                    : labelStyle,
                              ),
                            ),
                          ),
                  ))
              .values
              .toList(),
        );
    }
  }
}
