import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import '../apis/image_api.dart';
import '../utils/sid_image_result_decode.dart';

var logger = Logger();

class SidImage extends StatefulWidget {
  final String sid;
  final double width;
  final double height;
  final BoxFit fit;
  final Alignment alignment;
  final Function? onLoaded;
  final Function? onError;

  const SidImage({
    super.key,
    required this.sid,
    this.width = 200,
    this.height = 200,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.onLoaded,
    this.onError,
  });

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
    logger.d('widget.sid ===== ${widget.sid}');
    /**
     * 由sid當key, 去找hive中有沒有對應到的值
     * 有的話，由hive中取得並setState
     * 沒的話，呼叫ImageApi的getSidImageData，並存入hive以及setState
     */
    var hasFileInHive = sidImageBox.containsKey(widget.sid);
    logger.d('hasFileInHive ===== $hasFileInHive');
    if (hasFileInHive) {
      var file = await sidImageBox.get(widget.sid);
      setState(() {
        imageData = file;
      });
      widget.onLoaded!();
    } else {
      try {
        var res = await ImageApi().getSidImageData(widget.sid);
        var decoded = getSidImageDecode(res);
        var file = base64Decode(decoded);
        await sidImageBox.put(widget.sid, file);
        setState(() {
          imageData = file;
        });
        widget.onLoaded!();
      } catch (e) {
        logger.d(e);
        widget.onError!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageData.isEmpty) {
      return Container(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Image.memory(
      imageData,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      alignment: widget.alignment,
    );
  }
}
