import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_popular_controller.dart';
import 'package:shared/models/index.dart';
import 'package:shared/modules/channel/channe_provider.dart';
import 'package:shared/modules/main_layout/display_layout_tab_search_consumer.dart';
import 'package:shared/widgets/posts/card.dart';

const gradients = {
  1: [Color(0xFFf2f2f2), Color(0xFF45abb1)],
  2: [Color(0xFFf2f2f2), Color(0xFFc08e53)],
  3: [Color(0xFFf2f2f2), Color(0xFFff4545)],
};

final List<Map<String, dynamic>> mockData = [
  {
    "id": 1,
    "supplier": Supplier(
        aliasName: "尾巴殿下",
        coverVertical: "269e770a-b30c-45f7-975d-7d60ce2f8cb0",
        description: "各位尊貴的鏟屎官以及雲養寵的爸比媽咪 歡迎光臨尾巴殿下~",
        id: 2,
        name: "尾巴殿下",
        photoSid: "e0061cac-9579-40e5-a827-9bc153523fcc"),
    "upName": "Creator A",
    "postContent": "This is the first post content from Creator A."
  },
  {
    "id": 2,
    "supplier": Supplier(
        aliasName: "瑤瑤別追了1",
        coverVertical: "62db475f-0e05-4187-b5a3-64b4238ef754",
        description: "長視頻兩天一更，短視頻日更~~",
        id: 6,
        name: "瑤瑤別追了1",
        photoSid: "389972f3-73cb-4001-aa41-3951dd790586"),
    "upName": "Creator B",
    "postContent": "Here's a second post, but this time from Creator B."
  },
  {
    "id": 3,
    "supplier": Supplier(
      id: 22,
      aliasName: "\u912d\u8208A",
      name: "\u912d\u8208A",
      photoSid: "ebce8cec-765a-4536-afc8-f1e10ec18854",
      coverVertical: null,
      collectTotal: null,
      followTotal: null,
    ),
    "upName": "Creator C",
    "postContent": "Here's a third post, but this time from Creator B."
  },
  // 可以根據需要添加更多項目
];

class ChannelStyle7 extends StatelessWidget {
  final int channelId;
  final int layoutId;
  ChannelStyle7({Key? key, required this.channelId, required this.layoutId})
      : super(key: key);

  final actorPopularController = Get.put(SupplierPopularController());

  @override
  Widget build(BuildContext context) {
    return DisplayLayoutTabSearchConsumer(
      layoutId: layoutId,
      child: (({required bool displaySearchBar}) {
        return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.paddingOf(context).top +
                    (displaySearchBar ? 90 : 50)),
            child: ChannelProvider(
                channelId: channelId,
                widget: Scaffold(
                  body: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 4),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final item = mockData[index];
                            return PostCard(
                              postId: item["id"],
                              upName: item["upName"]!,
                              postContent: item["postContent"]!,
                              supplier: item["supplier"],
                            );
                          },
                          childCount: mockData.length,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 12),
                      ),
                    ],
                  ),
                )));
      }),
    );
  }
}
