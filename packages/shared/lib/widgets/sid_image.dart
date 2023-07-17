import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
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
  Uint8List? imageData;
  ImageProvider? image; // 用于存储解码后的图像

  @override
  void initState() {
    super.initState();
    getImage();
  }

  void getImage() async {
    var sidImageBox = await Hive.openBox('sidImage');

    if (widget.sid.isNotEmpty) {
      var hasFileInHive = sidImageBox.containsKey(widget.sid);
      if (hasFileInHive) {
        var file = await sidImageBox.get(widget.sid);
        try {
          image = await _decodeImage(file);
          if (mounted) {
            setState(() {});
          }
          if (widget.onLoaded != null) {
            widget.onLoaded!('success');
          }
        } catch (e) {
          // 解码失败，处理错误
          if (widget.onError != null) {
            widget.onError!(e);
          }
        }
      } else {
        try {
          var res = await ImageApi().getSidImageData(widget.sid);
          var decoded = getSidImageDecode(res!);
          var file = base64Decode(decoded);
          image = await _decodeImage(file);
          if (image != null) {
            await sidImageBox.put(widget.sid, file);
            if (mounted) {
              setState(() {});
            }
            if (widget.onLoaded != null) {
              widget.onLoaded!('success');
            }
          }
        } catch (e) {
          if (widget.onError != null) {
            widget.onError!(e);
          }
        }
      }
    }
  }

  Future<ImageProvider> _decodeImage(Uint8List file) async {
    await decodeImageFromList(file);
    return MemoryImage(file);
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
      );
    }
    if (widget.noFadeIn || kIsWeb) {
      return Image(
        image: image!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
      );
    }
    return FadeInEffect(
      child: Image(
        image: image!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
      ),
    );
  }
}
