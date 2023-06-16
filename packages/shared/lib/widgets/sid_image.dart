import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/fade_in_effect.dart';

import '../apis/image_api.dart';
import '../utils/sid_image_result_decode.dart';

var logger = Logger();

class SidImage extends StatefulWidget {
  final String sid;
  final double width;
  final double height;
  final BoxFit fit;
  final Alignment alignment;
  final Function(dynamic)? onLoaded;
  final Function(dynamic)? onError;
  final bool noFadeIn;

  const SidImage(
      {super.key,
      required this.sid,
      this.width = 200,
      this.height = 200,
      this.fit = BoxFit.cover,
      this.alignment = Alignment.center,
      this.onLoaded,
      this.onError,
      this.noFadeIn = false});

  @override
  State<SidImage> createState() => SidImageState();
}

class SidImageState extends State<SidImage> {
  late Uint8List imageData = Uint8List(0);

  @override
  void initState() {
    super.initState();
    getImage();
  }

  // async void getImage
  void getImage() async {
    var sidImageBox = await Hive.openBox('sidImage');

    //. print widget.sid
    // logger.d('widget.sid ===== ${widget.sid}');
    /**
     * 由sid當key, 去找hive中有沒有對應到的值
     * 有的話，由hive中取得並setState
     * 沒的話，呼叫ImageApi的getSidImageData，並存入hive以及setState
     */
    if (widget.sid.isNotEmpty) {
      var hasFileInHive = sidImageBox.containsKey(widget.sid);
      // logger.d('hasFileInHive ===== $hasFileInHive');
      if (hasFileInHive) {
        var file = await sidImageBox.get(widget.sid);
        if (mounted) {
          setState(() {
            imageData = file;
          });
        }
        if (widget.onLoaded != null) {
          widget.onLoaded!('success');
        }
      } else {
        try {
          var res = await ImageApi().getSidImageData(widget.sid);
          var decoded = getSidImageDecode(res);
          var file = base64Decode(decoded);
          await sidImageBox.put(widget.sid, file);

          if (mounted) {
            setState(() {
              imageData = file;
            });
          }
          if (widget.onLoaded != null) {
            widget.onLoaded!('success');
          }
        } catch (e) {
          // logger.d('${widget.sid}==ERROR=\n$e');
          // if widget.onError is not null, call it
          if (widget.onError != null) {
            widget.onError!(e);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageData.isEmpty) {
      return SizedBox(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Color(0xFF00234D), Color(0xFF002D62)],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        width: widget.width,
        height: widget.height,
      );
    }
    if (widget.noFadeIn) {
      return Image.memory(
        imageData,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
      );
    }
    return FadeInEffect(
      child: Image.memory(
        imageData,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
      ),
    );
  }
}
