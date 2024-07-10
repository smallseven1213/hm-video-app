import 'package:flutter/material.dart';
import 'package:shared/widgets/posts/card.dart'; // 請確保這裡的路徑是正確的

class ChannelStyle7 extends StatefulWidget {
  const ChannelStyle7({Key? key}) : super(key: key);

  @override
  ChannelStyle7State createState() => ChannelStyle7State();
}

class ChannelStyle7State extends State<ChannelStyle7> {
  // Mock data list
  final List<Map<String, String>> mockData = [
    {
      "upName": "Creator A",
      "postContent": "This is the first post content from Creator A."
    },
    {
      "upName": "Creator B",
      "postContent": "Here's a second post, but this time from Creator B."
    },
    // 可以根據需要添加更多項目
  ];

  @override
  Widget build(BuildContext context) {
    const baseTopHeight = 170;

    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + baseTopHeight),
      child: ListView.builder(
        itemCount: mockData.length,
        itemBuilder: (context, index) {
          final item = mockData[index];
          return PostCard(
            upName: item["upName"]!,
            postContent: item["postContent"]!,
          );
        },
      ),
    );
  }
}
