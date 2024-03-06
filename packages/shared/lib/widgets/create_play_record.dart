// CreatePlayRecord is a stateless widget, has props: VOD class -> video name, and return nothing more.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/play_record_controller.dart';
import '../enums/play_record_type.dart';
import '../models/vod.dart';

class CreatePlayRecord extends StatelessWidget {
  final Vod? video;
  final bool? supportedPlayRecord;
  final Widget child;

  const CreatePlayRecord(
      {Key? key,
      this.supportedPlayRecord,
      required this.video,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (supportedPlayRecord == false) {
      return child;
    }
    final PlayRecordController playRecordController =
        Get.find<PlayRecordController>(tag: PlayRecordType.short.toString());

    if (video != null) {
      try {
        var playRecord = Vod(
          video!.id,
          video!.title,
          coverHorizontal: video!.coverHorizontal,
          coverVertical: video!.coverVertical,
          timeLength: video!.timeLength!,
          tags: video!.tags!,
          videoViewTimes: video!.videoViewTimes,
        );
        playRecordController.addPlayRecord(playRecord);
      } catch (e) {
        rethrow;
      }
    }
    return child;
  }
}
