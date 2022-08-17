import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart';

bool isDebug() {
  return kIsWeb && window.location.host.contains(RegExp('pkonly8'));
}

bool isLocal() {
  return (kIsWeb && window.location.host.contains(RegExp('localhost')));
}

class VEndpoint {
  final String? host;
  final bool isWeb;
  final String? wildcard;
  String apiHost;
  String vodHost;
  List<String>? dl;
  List<String>? apl;

  VEndpoint({
    this.host,
    required this.apiHost,
    required this.vodHost,
    this.isWeb = false,
    this.dl,
    this.apl,
    this.wildcard,
  });

  Future<void> fetchDl() async {
    var res = await GetHttpClient().get(vodHost);
    var val = jsonDecode(res.bodyString ?? '{}');
    dl = List.from(val['dl'] as List<dynamic>);
    apl = List.from(val['apl'] as List<dynamic>);
    if (!kIsWeb) {
      apiHost = (apl ?? [])[0];
    }
    vodHost = (dl ?? [])[0];
  }

  String getApi() {
    if (isDebug()) {
      return 'https://dev-vm-api.pkonly8.com';
    }
    if (isWeb) {
      return 'https://api.$apiHost';
    }
    // return 'https://api.stt.bet';
    return 'https://api.${apl?.first ?? apiHost}';
  }

  String getPhotoSidPreviewPrefix() {
    if (isDebug()) {
      return 'https://dev-vm-api.pkonly8.com/public/photos/photo/preview?sid=';
    }
    if (isWeb) {
      return 'https://api.$apiHost/public/photos/photo/preview?sid=';
    }
    // return 'https://api.stt.bet/public/photos/photo/preview?sid=';
    return 'https://api.${apl?.first ?? apiHost}/public/photos/photo/preview?sid=';
  }

  String getVideoPrefix() {
    if (isDebug()) {
      return 'https://dev-vm-video.pkonly8.com';
    }
    return 'https://${dl?.first ?? vodHost}';
  }

  factory VEndpoint.from() {
    if (kIsWeb) {
      var host = isLocal() ? 'ABCD.stt018.com' : window.location.host;
      var idx = host.indexOf('.');
      var wildcard = host.substring(idx < 0 ? 0 : idx + 1);
      return VEndpoint(
        host: host,
        apiHost: wildcard,
        vodHost: 'https://dl.0272pay.com/dl.json',
        wildcard: wildcard,
        isWeb: true,
      );
    }
    return VEndpoint(
      apiHost: 'https://dl.0272pay.com/dl.json',
      vodHost: 'https://dl.0272pay.com/dl.json',
    );
  }
}
