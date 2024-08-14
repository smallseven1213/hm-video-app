import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared/apis/image_api.dart';
import 'package:shared/utils/sid_image_result_decode.dart';
import 'package:shared/widgets/fade_in_effect.dart';

class SidImage extends StatefulWidget {
  final String sid;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;

  final Function(String)? onLoaded;
  final Function(dynamic)? onError;
  final bool noFadeIn;

  const SidImage({
    Key? key,
    required this.sid,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.onLoaded,
    this.onError,
    this.noFadeIn = false,
  }) : super(key: key);

  @override
  State<SidImage> createState() => SidImageState();
}

class SidImageState extends State<SidImage> {
  Uint8List? image;
  late double _width;
  late double _height;

  @override
  void initState() {
    super.initState();
    _width = widget.width ?? 200;
    _height = widget.height ?? 200;
    getImage();
  }

  Future<Uint8List?> _decodeImage(Uint8List file) async {
    final codec = await instantiateImageCodec(file);
    final frame = await codec.getNextFrame();
    final aspectRatio = frame.image.width / frame.image.height;

    if (widget.width == null && widget.height == null) {
      // 如果寬度和高度都沒有提供，使用默認值
      _width = 200;
      _height = 200;
    } else if (widget.width == null) {
      // 如果只提供了高度，根據高度和圖片比例計算寬度
      _height = widget.height!;
      _width = _height * aspectRatio;
    } else if (widget.height == null) {
      // 如果只提供了寬度，根據寬度和圖片比例計算高度
      _width = widget.width!;
      _height = _width / aspectRatio;
    } else {
      // 如果寬度和高度都提供了，直接使用
      _width = widget.width!;
      _height = widget.height!;
    }

    return file;
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

  @override
  Widget build(BuildContext context) {
    return image == null
        ? SizedBox(width: _width, height: _height)
        : widget.noFadeIn
            ? Image.memory(
                image!,
                width: _width,
                height: _height,
                fit: widget.fit,
                alignment: widget.alignment,
              )
            : FadeInEffect(
                child: Image.memory(
                  image!,
                  width: widget.width,
                  height: widget.height,
                  fit: widget.fit,
                  alignment: widget.alignment,
                ),
              );
    ;
  }
}
