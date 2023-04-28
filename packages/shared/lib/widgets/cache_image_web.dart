import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;

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
  _CacheImageWebState createState() => _CacheImageWebState();
}

class _CacheImageWebState extends State<CacheImageWeb> {
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
    final box = Hive.box('images');

    if (box.containsKey(url)) {
      // If the image is in the box, get it from the box
      final record = box.get(url);
      if (record != null) {
        setState(() {
          imageData = Uint8List.fromList(record);
        });
      }
    } else {
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          // If the response is successful, save the image to the box
          box.put(url, response.bodyBytes);
          setState(() {
            imageData = response.bodyBytes;
          });
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
                const Center(child: CircularProgressIndicator()),
                Image.asset(
                  widget.emptyImageUrl!,
                  width: widget.width,
                  height: widget.height,
                  fit: widget.fit,
                ),
              ],
            )
          : const CircularProgressIndicator();
    }

    return Image.memory(
      imageData,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }
}
