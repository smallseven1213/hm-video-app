// MainChannelScreen, is a screen that shows the channel list and the channel details

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../pages/video.dart';

class MainChannelScreen extends StatelessWidget {
  final String channelId;

  const MainChannelScreen({Key? key, required this.channelId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Channel - $channelId'),
      ),
      body: ListView.builder(
        itemCount: 1000,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            child: TextButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (BuildContext context) {
                //       return const Video();
                //     },
                //   ),
                // );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Video()),
                );
              },
              child: Text('Video $index'),
            ),
          );
        },
      ),
    );
  }
}
