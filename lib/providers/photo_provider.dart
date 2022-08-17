import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class PhotoProvider {
  Future<String> uploadPhoto(XFile file) async {
    var auth = await AuthProvider.authenticator(
        Request(url: Uri.parse(''), method: '', headers: {}));
    var sid = const Uuid().v4();
    var dio = Dio();
    var form = FormData.fromMap({
      'sid': sid,
      'photo': MultipartFile.fromBytes(
        await file.readAsBytes(),
        filename: file.name,
        contentType: http_parser.MediaType.parse(file.mimeType ?? 'image/png'),
      ),
    });
    var res = await dio.post(
      '${AppController.cc.endpoint.getApi()}/public/photos/photo',
      data: form,
      options: Options(
        headers: {
          'Authorization': auth.headers['Authorization'],
        },
      ),
    );
    await dio.put(
      '${AppController.cc.endpoint.getApi()}/public/users/user/avatar',
      data: {
        'photoName': sid,
      },
      options: Options(
        headers: {
          'Authorization': auth.headers['Authorization'],
        },
      ),
    );
    return sid;
  }
}
