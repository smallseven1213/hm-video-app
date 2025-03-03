import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_list_controller.dart';

import '../../localization/live_localization_delegate.dart';

class SortWidget extends StatelessWidget {
  const SortWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return InkWell(
      onTap: () => _showSortBottomSheet(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Image(
            image:
                AssetImage('packages/live_ui_basic/assets/images/ic_sort.webp'),
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 4),
          Text(
            localizations.translate('sort'),
            style: const TextStyle(color: Color(0xff9a9ba1), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  SelectionScreenState createState() => SelectionScreenState();
}

class SelectionScreenState extends State<SelectionScreen> {
  int? selectedOption;
  final LiveListController liveListController = Get.find<LiveListController>();

  void sortRooms(int index) {
    SortType sortType = SortType.defaultSort;
    switch (index) {
      case 0:
        sortType = SortType.defaultSort;
        break;
      case 1:
        sortType = SortType.watch;
        break;
      case 2:
        sortType = SortType.income;
        break;
      case 3:
        sortType = SortType.newcomer;
        break;
      default:
        break;
    }
    liveListController.setSortType(sortType);
  }

  Widget optionTile(String title, int index) {
    return Obx(() {
      bool isSelected = liveListController.sortType.value.index == index;
      return ListTile(
        title: Text(
          title,
          style: TextStyle(color: isSelected ? Colors.purple : Colors.white),
        ),
        trailing:
            isSelected ? const Icon(Icons.check, color: Colors.purple) : null,
        onTap: () => sortRooms(index),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return ListView(
      children: <Widget>[
        optionTile(localizations.translate('default_sorting'), 0),
        const Divider(color: Colors.white),
        optionTile(localizations.translate('most_viewed'), 1),
        const Divider(color: Colors.white),
        optionTile(localizations.translate('most_followed'), 2),
        const Divider(color: Colors.white),
        optionTile(localizations.translate('new_hosts'), 3),
      ],
    );
  }
}

void _showSortBottomSheet(BuildContext context) {
  final LiveLocalizations localizations = LiveLocalizations.of(context)!;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Wrap(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 8, bottom: 20),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 做一個篩選title跟右上的關閉按鈕
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      localizations.translate('sorting_condition'),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 250, child: SelectionScreen()),
              ],
            ),
          )
        ],
      );
    },
  );
}
