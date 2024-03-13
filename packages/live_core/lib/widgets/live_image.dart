import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared/utils/sid_image_result_decode.dart';

class LiveImage extends StatefulWidget {
  final String base64Url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment? alignment;

  const LiveImage({
    Key? key,
    required this.base64Url,
    this.width,
    this.height,
    this.fit,
    this.alignment,
  }) : super(key: key);

  @override
  _LiveImageState createState() => _LiveImageState();
}

class _LiveImageState extends State<LiveImage> {
  late Future<ImageProvider<Object>?> _imageProvider;

  Future<ImageProvider> _decodeImage(Uint8List file) async {
    await decodeImageFromList(file);
    return MemoryImage(file);
  }

  Future<ImageProvider<Object>?> _fetchImageData() async {
    final response = await http.get(Uri.parse(widget.base64Url));
    if (response.statusCode == 200) {
      var decoded = getSidImageDecode(response.body);
      var file = base64Decode(decoded);
      return await _decodeImage(file);
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  void initState() {
    super.initState();
    _imageProvider = _fetchImageData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider<Object>?>(
      future: _imageProvider,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData
              ? Image(
                  key: ValueKey(snapshot.data),
                  image: snapshot.data!,
                  width: widget.width ?? double.infinity,
                  height: widget.height ?? double.infinity,
                  fit: widget.fit ?? BoxFit.cover,
                  alignment: widget.alignment ?? Alignment.center,
                )
              : Container(
                  width: widget.width,
                  height: widget.height,
                  color: const Color(0xFF242a3d),
                  alignment: Alignment.center,
                ),
        );
      },
    );
  }
}
