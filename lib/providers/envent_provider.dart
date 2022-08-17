import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/models/event.dart';
import 'package:wgp_video_h5app/providers/index.dart';

import '../shard.dart';

class EventProvider extends BaseProvider {
  @override
  void onInit() {
    httpClient.baseUrl = '${AppController.cc.endpoint.getApi()}/public/events';
    super.onInit();
  }

  Future<List<Event>> getMany({int page = 1, int limit = 100}) =>
      get('/event/list').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        if (res['data'] != null) {
          return List.from(res['data'] as List<dynamic>)
              .map((e) => Event.fromJson(e))
              .toList();
        }
        return [];
      });

  Future<List<Event>> getLatest() =>
      get('/event/latest').then((value) {
        var res = (value.body as Map<String, dynamic>);
        if (res['code'] != '00') {
          return [];
        }
        if (res['data'] != null && (res['data'] as List<dynamic>).isNotEmpty) {
          return List.from(res['data'] as List<dynamic>)
              .map((e) => Event.fromJson(e))
              .toList();
        }
        return [];
      });

  Future<bool> putLatest() async {
    List<Event> events = await getLatest();
    return SharedPreferencesUtil.setEventLatest(events);
  }

  Future<void> deleteEvent(List<int> eventId) => delete(
    '/event?id=${eventId.join(',')}',
  );

}
