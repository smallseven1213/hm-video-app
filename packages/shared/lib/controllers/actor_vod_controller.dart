import '../apis/actor_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';

final actorApi = ActorApi();
const limit = 100;

class ActorVodController extends BaseVodInfinityScrollController {
  final int actorId;

  ActorVodController({required this.actorId, bool loadDataOnInit = true})
      : super(loadDataOnInit: loadDataOnInit);

  @override
  Future<InfinityVod> fetchData(int page) async {
    var res = await actorApi.getManyLatestVodBy(
        page: page, actorId: actorId, limit: limit);

    bool hasReachedEnd = res.total > limit * page;

    return InfinityVod(res.vods, res.total, hasReachedEnd);
  }
}
