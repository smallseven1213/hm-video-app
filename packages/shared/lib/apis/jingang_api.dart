import '../models/jingang.dart';
import '../utils/fetcher.dart';

class JingangApi {
  Future<List<JinGang>> getMany(List<int> jingang) async {
    var res = await fetcher(url: '/jingang/list?id=${jingang.join(',')}');
    if (res.data['code'] != '00') {
      return [];
    }
    return List.from(
        (res.data['data'] as List<dynamic>).map((e) => JinGang.fromJson(e)));
  }

  Future<void> addBannerClickRecord(int jingangId) async {
    if (jingangId == 0) {
      throw Exception('jingangId is 0');
    }
    fetcher(url: '/jingang/jingangClickRecord', method: 'POST', body: {
      'jingangId': jingangId,
    });
  }
}
