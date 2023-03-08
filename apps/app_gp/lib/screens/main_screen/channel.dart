import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_data_controller.dart';

import '../../pages/video.dart';

class MainChannelScreen extends StatelessWidget {
  final int channelId;

  MainChannelScreen({Key? key, required this.channelId}) : super(key: key);

  final ChannelDataController channelDataController =
      Get.find<ChannelDataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Channel - $channelId'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: channelDataController.channelData[channelId]?.length,
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Video()),
                  );
                },
                child: Text(
                    channelDataController.channelData[channelId]![index].name),
              ),
            );
          },
        ),
      ),
      // body: ListView.builder(
      //   itemCount: 1000,
      //   itemBuilder: (context, index) {
      //     return Container(
      //       height: 100,
      //       child: TextButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => const Video()),
      //           );
      //         },
      //         child: Text('Video $index'),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
