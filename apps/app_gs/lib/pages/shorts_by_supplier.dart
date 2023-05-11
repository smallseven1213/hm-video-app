import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_short_by_supplier_controller.dart';
import '../widgets/base_short_page.dart';

final logger = Logger();

class ShortsBySupplierPage extends BaseShortPage {
  ShortsBySupplierPage(
      {super.key, required int videoId, required int supplierId})
      : super(
          videoId: videoId,
          itemId: supplierId,
          createController: () =>
              Get.put(VideoShortBySupplierController(supplierId, videoId)),
        );
}
