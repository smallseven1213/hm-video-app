import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/ads_api.dart';
import 'package:shared/models/ad.dart';

final logger = Logger();

class AppsController extends GetxController {
  final hot = <Ads>[].obs;
  final popular = <Ads>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppsData();
  }

  Future<void> fetchAppsData() async {
    try {
      isLoading.value = true;
      var results = await Future.wait([
        AdsApi().getManyBy(),
        AdsApi().getRecommendBy(),
      ]);

      popular.value = results[0];
      hot.value = results[1];
    } catch (e) {
      logger.e('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
