import '../apis/vod_api.dart';
import '../models/infinity_vod.dart';
import 'base_vod_infinity_scroll_controller.dart';

final vodApi = VodApi();
const limit = 20;

class SearchVodController extends BaseVodInfinityScrollController {
  final String keyword;
  final int film;

  SearchVodController(
      {required this.keyword, required this.film, bool loadDataOnInit = true})
      : super(
          loadDataOnInit: loadDataOnInit,
        );

  @override
  Future<InfinityVod> fetchData(int page) async {
    var res = await vodApi.searchMany(keyword, page, limit, film);

    bool hasMoreData = res.total > limit * page;

    return InfinityVod(res.vods, res.total, hasMoreData);
  }
}
