import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared/utils/sid_image_result_decode.dart';

class LiveImage extends StatelessWidget {
  final String base64Url;

  // Make sure to define these properties in your class
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment? alignment;

  const LiveImage(
      {Key? key,
      required this.base64Url,
      this.width,
      this.height,
      this.fit,
      this.alignment})
      : super(key: key);

  Future<ImageProvider> _decodeImage(Uint8List file) async {
    await decodeImageFromList(file);
    return MemoryImage(file);
  }

  Future<ImageProvider<Object>?> _fetchImageData() async {
    final response = await http.get(Uri.parse(base64Url));
    if (response.statusCode == 200) {
      var decoded = getSidImageDecode(response
          .body); // Ensure getSidImageDecode is defined and working correctly
      var file = base64Decode(decoded);
      var image = await _decodeImage(file);
      return image;
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider<Object>?>(
      future: _fetchImageData(),
      builder: (BuildContext context,
          AsyncSnapshot<ImageProvider<Object>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Container(
            color: Colors.grey,
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (snapshot.hasData) {
          return Image(
            image: snapshot.data!,
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            fit: fit ?? BoxFit.cover, // Provide a default value if fit is null
            alignment: alignment ??
                Alignment
                    .center, // Provide a default value if alignment is null
          );
        } else {
          return Text('No image data');
        }
      },
    );
  }
}
