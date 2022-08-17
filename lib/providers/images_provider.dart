import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as crypt;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:universal_io/io.dart' as io;
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class ImagesProvider extends BaseProvider {
  late StoreRef _store;
  late crypt.IV iv;

  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getVideoPrefix()}/images';
    _store = StoreRef.main();
    super.onInit();
  }

  Image _genImage(
    Uint8List data, {
    double? width,
    double? height,
    BoxFit? fit,
    Function(Widget)? placeholder,
  }) =>
      Image.memory(
        data,
        fit: fit ?? BoxFit.fitWidth,
        alignment: Alignment.center,
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        // cacheWidth: width?.ceil(),
        // cacheHeight: height?.ceil(),
        frameBuilder: (BuildContext context, Widget child, int? frame,
                bool wasSynchronouslyLoaded) =>
            wasSynchronouslyLoaded
                ? child
                : placeholder == null
                    ? AnimatedOpacity(
                        child: child,
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 160),
                        curve: Curves.linear,
                      )
                    : placeholder(AnimatedOpacity(
                        child: child,
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 160),
                        curve: Curves.linear,
                      )),
      );

  String _decode(
    String word, {
    int posStartAt = 0,
    String posChar = 'p',
    int posLen = 3,
    int passLen = 16,
  }) {
    var dePos = word.substring(posStartAt, posLen);
    var pos = int.parse(dePos.replaceAll(posChar, ''));
    return word.substring(posLen, posLen + pos) +
        word.substring(posLen + pos + passLen);
  }

  Future<Image?> getImage(
    String sid, {
    double? width,
    double? height,
    BoxFit? fit,
    Function(Widget)? placeholder,
  }) async {
    if (sid.isEmpty) {
      return Future.value(null);
    }
    if (kIsWeb) {
      if (await _store.record(sid).exists(AppController.cc.db)) {
        return Future.value(_genImage(
          base64Decode(await _store.record(sid).get(AppController.cc.db)),
          width: width,
          height: height,
          placeholder: placeholder,
          fit: fit,
        ));
      }
    } else {
      var dir = await getApplicationDocumentsDirectory();
      var file = io.File(join(dir.path, "$sid.png"));
      if (await file.exists()) {
        return Future.value(_genImage(
          await file.readAsBytes(),
          width: width,
          height: height,
          placeholder: placeholder,
          fit: fit,
        ));
      }
    }
    return get('/$sid').then((value) async {
      // print('image - $sid - responsed');
      try {
        var res = (value.body as String);
        var decoded = await Future.microtask(() async {
          var decoded = _decode(res.toString());
          // print('image - $sid - decoded');
          try {
            if (kIsWeb) {
              _store.record(sid).put(AppController.cc.db, decoded);
            } else {
              var dir = await getApplicationDocumentsDirectory();
              await io.File(join(dir.path, "$sid.png"))
                  .writeAsBytes(base64Decode(decoded));
            }
          } catch (err) {}
          // print('image - $sid - storaged');
          return decoded;
        });

        return _genImage(
          base64Decode(decoded),
          width: width,
          height: height,
          placeholder: placeholder,
          fit: fit,
        );
      } catch (e) {
        return Image.asset('assets/img/img-default@3x.png');
      }
    });
  }
}
