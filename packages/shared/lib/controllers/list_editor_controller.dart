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
    selectedIds.clear();
    selectedIds.addAll(ids);
  }

  void removeBoundData(List<int> ids) {
    selectedIds.removeWhere((id) => ids.contains(id));
  }

  void clearSelected() {
    selectedIds.clear();
  }
}
