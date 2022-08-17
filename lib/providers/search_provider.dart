import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';

class KeywordItem {
  final int id;
  final String name;
  final String type;

  KeywordItem(this.id, this.name, this.type);
  factory KeywordItem.fromJson(Map<String, dynamic> json, String type) {
    return KeywordItem(json['id'], (json['aliasName'] ?? json['name']), type);
  }
}

class KeywordItemV2 {
  final String name;
  final String type;

  KeywordItemV2(this.name, this.type);
  factory KeywordItemV2.fromJson(Map<String, dynamic> json, String type) {
    return KeywordItemV2(json['name'], type);
  }
}

class SearchProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/videos';
    super.onInit();
  }

  Future<List<KeywordItemV2>> getSearchKeys(String keyword) {
    if (keyword.isEmpty) {
      return Future(() {
        return [];
      });
    }
    return get('/video/keywordV2?keyword=$keyword').then((value) {
      var res = (value.body as Map<String, dynamic>);
      if (res['code'] != '00') {
        return [];
      }
      return [
        ...List.from((res['data'] as List<dynamic>)
            .map((e) => KeywordItemV2.fromJson(e, 'name'))),
      ];
    });
  }

  Future<List<KeywordItem>> getMany(String keyword) {
    if (keyword.isEmpty) {
      return Future(() {
        return [];
      });
    }
    return get('/video/keyword?keyword=$keyword').then((value) {
      var res = (value.body as Map<String, dynamic>);
      if (res['code'] != '00') {
        return [];
      }
      return [
        ...List.from((res['data']['tag'] as List<dynamic>)
            .map((e) => KeywordItem.fromJson(e, 'tag'))),
        ...List.from((res['data']['actor'] as List<dynamic>)
            .map((e) => KeywordItem.fromJson(e, 'actor'))),
        ...List.from((res['data']['publisher'] as List<dynamic>)
            .map((e) => KeywordItem.fromJson(e, 'publisher'))),
        ...List.from((res['data']['supplier'] as List<dynamic>)
            .map((e) => KeywordItem.fromJson(e, 'supplier'))),
        ...List.from((res['data']['externalId'] as List<dynamic>)
            .map((e) => KeywordItem.fromJson(e, 'externalId'))),
      ];
    });
  }

  Future<List<Tag>> getPopular() async {
    var value = await get('/video/recommendKeyword');
    var res = (value.body as Map<String, dynamic>);
    if (res['code'] != '00') {
      return [];
    }
    return List.from(
        (res['data'] as List<dynamic>).map((e) => Tag.fromJson(e)));
  }
}
