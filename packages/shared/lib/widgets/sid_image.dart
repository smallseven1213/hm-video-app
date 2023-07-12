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
  late Uint8List imageData = Uint8List(0);
  late bool imageError = false; // 用於追蹤是否有圖像解碼錯誤

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

          // 嘗試解碼圖像
          try {
            await decodeImageFromList(file);
            // 如果上面的行没有抛出异常，那么就可以安全地认为解码成功
          } catch (e) {
            // 解码失败
            imageError = true;
          }

          if (!imageError) {
            await sidImageBox.put(widget.sid, file);
            if (mounted) {
              setState(() {
                imageData = file;
              });
            }
            if (widget.onLoaded != null) {
              widget.onLoaded!('success');
            }
          } else {
            // 處理錯誤，如果需要的話
          }
        } catch (e) {
          if (widget.onError != null) {
            widget.onError!(e);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageData.isEmpty || imageError) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
      );
    }
    if (widget.noFadeIn || kIsWeb) {
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
