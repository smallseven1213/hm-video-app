import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
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

  static final imageCache = <String, Uint8List>{};

  @override
  void initState() {
    super.initState();
    getImage();
  }

  // async void getImage
  void getImage() async {
    if (widget.sid.isNotEmpty) {
      if (imageCache.containsKey(widget.sid)) {
        var file = imageCache[widget.sid];
        if (file != null) {
          setState(() {
            imageData = file;
          });
          if (widget.onLoaded != null) {
            widget.onLoaded!('success');
          }
        }
      } else {
        try {
          var res = await ImageApi().getSidImageData(widget.sid);
          var decoded = getSidImageDecode(res);
          var file = base64Decode(decoded);
          imageCache[widget.sid] = file;

          setState(() {
            imageData = file;
          });
          if (widget.onLoaded != null) {
            widget.onLoaded!('success');
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
    if (imageData.isEmpty) {
      return SizedBox(
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
