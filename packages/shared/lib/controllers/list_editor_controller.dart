import 'package:get/get.dart';

class ListEditorController extends GetxController {
  final isEditing = false.obs;
  final selectedIds = <int>{}.obs;

  @override
  void onInit() {
    ever(isEditing, (isEditing) {
      if (!isEditing) {
        clearSelected();
      }
    });
    super.onInit();
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value;
  }

  void closeEditing() {
    isEditing.value = false;
  }

  void toggleSelected(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void saveBoundData(List<int> ids) {
    // 如果selectedIds有值，就直接清控不加入，反之則會addAll一次
    if (selectedIds.isEmpty) {
      selectedIds.clear();
      selectedIds.addAll(ids);
    } else {
      selectedIds.clear();
    }
  }

  void removeBoundData(List<int> ids) {
    selectedIds.removeWhere((id) => ids.contains(id));
  }

  void clearSelected() {
    selectedIds.clear();
  }
}
