import '../utils/fetcher.dart';

String apiPrefix = '${systemConfig.apiHost}/public/jingangs';

class JingangApi {
  Future<void> recordJingangClick(int jingangId) async {
    if (jingangId == 0) {
      throw Exception('jingangId is 0');
    }
    fetcher(
        url: '$apiPrefix/jingang/jingangClickRecord',
        method: 'POST',
        body: {
          'jingangId': jingangId,
        });
  }
}
