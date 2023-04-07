import 'package:app_gp/screens/search/tag_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/tag_popular_controller.dart';

import '../../widgets/header.dart';

class RecommandScreen extends StatelessWidget {
  final TagPopularController tagPopularController = Get.find();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const SliverToBoxAdapter(
          child: Header(
            text: '搜索推荐',
          ),
        ),
        // SliverList(
        //   delegate: SliverChildListDelegate([
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Wrap(
        //         spacing: 8, // 標籤之間的水平間距
        //         runSpacing: 8, // 標籤之間的垂直間距
        //         children: tags
        //             .map((tag) => TagItem(tag: tag))
        //             .toList()
        //             .cast<Widget>(),
        //       ),
        //     ),
        //   ]),
        // ),
        // wrap with Obx
        Obx(() => SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8, // 標籤之間的水平間距
                    runSpacing: 8, // 標籤之間的垂直間距
                    children: tagPopularController.data
                        .map((tag) => TagItem(tag: tag.name))
                        .toList()
                        .cast<Widget>(),
                  ),
                ),
              ]),
            )),
        const SliverToBoxAdapter(
          child: Header(
            text: '热门推荐',
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
