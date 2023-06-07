import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:game/utils/loading.dart';
import 'package:hive_flutter/adapters.dart';

class CacheImageWeb extends StatefulWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  final String? emptyImageUrl;

  const CacheImageWeb({
    Key? key,
    required this.url,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
    this.emptyImageUrl,
  }) : super(key: key);

  @override
  CacheImageWebState createState() => CacheImageWebState();
}

class CacheImageWebState extends State<CacheImageWeb> {
  Uint8List imageData = Uint8List(0);

  @override
  void initState() {
    super.initState();
    initHive();
    _loadImageFromUrl(widget.url);
  }

  void initHive() async {
    await Hive.initFlutter();
    await Hive.openBox('images');
  }

  void _loadImageFromUrl(String url) async {
    await Hive.openBox('images');
    final box = await Hive.openBox('images'); // 等待Hive初始化完成

    if (box.containsKey(url)) {
      // If the image is in the box, get it from the box
      final record = box.get(url);
      if (record != null) {
        final data = List<int>.from(record);
        setState(() {
          imageData = Uint8List.fromList(data);
        });
      }
    } else {
      try {
        final dio = Dio();
        final response = await dio.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
        if (response.statusCode == 200) {
          if (response.data != null) {
            final data = List<int>.from(response.data.cast<int>());
            box.put(url, data);
            setState(() {
              imageData = Uint8List.fromList(data);
            });
          }
        } else {
          setState(() {
            imageData = Uint8List(0);
          });
        }
      } catch (e) {
        setState(() {
          imageData = Uint8List(0);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageData.isEmpty) {
      return widget.emptyImageUrl != null
          ? Stack(
              children: [
                const Center(child: GameLoading()),
                Image.asset(
                  widget.emptyImageUrl!,
                  width: widget.width,
                  height: widget.height,
                  fit: widget.fit,
                ),
              ],
            )
          : const GameLoading();
    }

    return Image.memory(
      imageData,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }
}
