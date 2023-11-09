import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:shared/models/index.dart';

import '../apis/user_api.dart';

final userApi = UserApi();
final logger = Logger();

class UserFavoritesSupplierController extends GetxController {
  static const String _boxName = 'userFavoritesSupplier';
  late Box<String> box;
  var suppliers = <Supplier>[].obs;

  @override
  void onInit() {
    super.onInit();
    _init();
    Get.find<AuthController>().token.listen((event) {
      _init();
    });
  }

  Future<void> _init() async {
    box = await Hive.openBox<String>(_boxName);

    if (box.isNotEmpty) {
      suppliers.value = box.values.map((supplierStr) {
        final supplierJson = jsonDecode(supplierStr) as Map<String, dynamic>;
        return Supplier.fromJson(supplierJson);
      }).toList();
    } else {
      await _fetchAndSaveCollection();
    }
  }

  Future<void> _fetchAndSaveCollection() async {
    var supplierList = await userApi.getFavoriteSupplier();
    suppliers.value = supplierList;
    await _updateHive();
  }

  void addSupplier(Supplier supplier) async {
    if (suppliers.firstWhereOrNull((v) => v.id == supplier.id) != null) {
      suppliers.removeWhere((v) => v.id == supplier.id);
    }

    // Insert the new Supplier at the beginning of the list.
    suppliers.insert(0, supplier);
    await _updateHive();
    userApi.addFavoritSupplier(supplier.id!);
  }

  void removeSupplier(List<int> ids) async {
    suppliers.removeWhere((v) => ids.contains(v.id));
    await _updateHive();
    userApi.deleteActorFavorite(ids);
  }

  Future<void> _updateHive() async {
    await box.clear();
    for (var supplier in suppliers) {
      final supplierStr = jsonEncode(supplier.toJson());
      await box.put(supplier.id.toString(), supplierStr);
    }
  }

  bool isSupplierLiked(int supplierId) {
    return suppliers.any((supplier) => supplier.id == supplierId);
  }
}
