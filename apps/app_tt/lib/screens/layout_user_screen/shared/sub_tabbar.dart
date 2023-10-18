import 'package:flutter/material.dart';

class SubTabBar extends StatelessWidget {
  const SubTabBar({
    Key? key,
    required this.controller,
    required this.tabs,
    required this.onSelectAll,
    required this.isEditing,
  }) : super(key: key);

  final TabController controller;
  final List<String> tabs;
  final VoidCallback onSelectAll;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 44,
      pinned: true,
      backgroundColor: Colors.white,
      title: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: TabBar(
                controller: controller,
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicator:
                    const BoxDecoration(), // Setting a BoxDecoration with no properties will remove the underline
                tabs: tabs
                    .map((e) => Container(
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFFf3f3f4),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          alignment: Alignment.center,
                          child: Text(e),
                        ))
                    .toList(),
              ),
            ),
            Positioned(
              right: 0,
              child: InkWell(
                onTap: onSelectAll,
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Align(
                    alignment: Alignment(0.0, -0.7),
                    child: SizedBox(
                      width: 14,
                      height: 14,
                      child: Image(
                        fit: BoxFit.contain,
                        image: AssetImage(
                          'assets/images/trashcan.webp',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
