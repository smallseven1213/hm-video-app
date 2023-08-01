import 'package:logger/logger.dart';

import '../apis/actor_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';

final actorApi = ActorApi();
final logger = Logger();
const limit = 20;

class ActorLatestVodController extends BaseVodInfinityScrollController {
  final int actorId;

  ActorLatestVodController({required this.actorId, bool loadDataOnInit = true})
      : super(
          loadDataOnInit: loadDataOnInit,
        );

  @override
  Future<InfinityVod> fetchData(int page) async {
    var res = await actorApi.getManyLatestVodBy(
        page: page, actorId: actorId, limit: limit);

    bool hasMoreData = res.total > limit * page;

    return InfinityVod(res.vods, res.total, hasMoreData);
  }
}
