import 'package:shared/apis/tag_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';

final tagApi = TagApi();
const limit = 100;

class TagVodController extends BaseVodInfinityScrollController {
  final int tagId;

  TagVodController({required this.tagId, bool loadDataOnInit = true})
      : super(loadDataOnInit: loadDataOnInit);

  @override
  Future<InfinityVod> fetchData(int page) async {
    var res =
        await tagApi.getRecommendVod(page: page, tagId: tagId, limit: limit);

    bool hasMoreData = res.total > limit * page;

    return InfinityVod(res.vods, res.total, hasMoreData);
  }
}
