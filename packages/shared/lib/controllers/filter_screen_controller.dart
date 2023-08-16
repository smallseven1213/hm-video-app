import 'package:get/get.dart';

class FilterScreenController extends GetxController {
  final RxMap<String, Set> selectedOptions = <String, Set>{}.obs;
  final showTabBar = true.obs;
  final selectedBarOpen = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void handleOptionChange(String key, dynamic value) {
    if (selectedOptions.containsKey(key)) {
      if (selectedOptions[key]!.contains(value)) {
        selectedOptions[key]!.remove(value);
      } else {
        selectedOptions[key]!.add(value);
      }
    } else {
      selectedOptions[key] = {value};
    }
  }

  handleOption({
    bool showTab = true,
    bool openOption = false,
  }) {
    showTabBar.value = showTab;
    selectedBarOpen.value = openOption;
  }
}
