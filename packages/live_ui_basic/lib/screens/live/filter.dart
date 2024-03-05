import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_core/models/room.dart';

import '../../localization/live_localization_delegate.dart';

class Option {
  final String name;
  dynamic value;

  Option({required this.name, required this.value});
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return InkWell(
      onTap: () => _showFilterBottomSheet(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Image(
            image: AssetImage(
                'packages/live_ui_basic/assets/images/ic_select.webp'),
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 4),
          Text(
            localizations.translate('filter'),
            style: const TextStyle(color: Color(0xff9a9ba1), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const FilterButton({
    Key? key,
    required this.text,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: isActive ? const Color(0xffae57ff) : Color(0xff565656),
          ),
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ));
  }
}

class FilterGroup extends StatelessWidget {
  final List<Option> options;
  final String title;
  final String name;
  final dynamic defaultValue;

  final LiveListController liveListController = Get.find<LiveListController>();

  FilterGroup({
    Key? key,
    required this.options,
    required this.title,
    this.name = 'name',
    this.defaultValue,
  }) : super(key: key);

  void filter(Option option) {
    if (name == 'chargeType') {
      liveListController.setChargeType(option.value);
    } else if (name == 'status') {
      liveListController.setStatus(option.value);
    } else if (name == 'follow') {
      liveListController.setFollowType(option.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    var activeOption = options.firstWhere(
        (option) => option.value == defaultValue,
        orElse: () => options.first);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: const TextStyle(color: Colors.white)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: options.map((option) {
            return Container(
                margin: const EdgeInsets.only(right: 10, top: 10),
                child: FilterButton(
                  text: option.name,
                  isActive: option == activeOption,
                  onTap: () => filter(option),
                ));
          }).toList(),
        ),
      ],
    );
  }
}

void _showFilterBottomSheet(BuildContext context) {
  LiveListController liveListController = Get.find<LiveListController>();
  final LiveLocalizations localizations = LiveLocalizations.of(context)!;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Wrap(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 8, bottom: 30),
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
                      localizations.translate('filter'),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return FilterGroup(
                    title: localizations.translate('followed_host'),
                    name: 'follow',
                    options: [
                      Option(
                          name: localizations.translate('unlimited'),
                          value: FollowType.none),
                      Option(
                          name: localizations.translate('followed_hosts'),
                          value: FollowType.followed),
                    ],
                    defaultValue: liveListController.followType.value,
                  );
                }),
                const SizedBox(height: 20),
                Obx(() {
                  return FilterGroup(
                    title: localizations.translate('type_of_payment'),
                    name: 'chargeType',
                    options: [
                      Option(
                          name: localizations.translate('unlimited'),
                          value: RoomChargeType.none),
                      Option(
                          name: localizations.translate('free_live'),
                          value: RoomChargeType.free),
                      Option(
                          name: localizations.translate('paid_live'),
                          value: RoomChargeType.oneTime),
                    ],
                    defaultValue: liveListController.chargeType.value,
                  );
                }),
                const SizedBox(height: 20),
                Obx(() {
                  return FilterGroup(
                    title: localizations.translate('type_of_live_broadcast'),
                    name: 'status',
                    options: [
                      Option(
                          name: localizations.translate('unlimited'),
                          value: RoomStatus.none),
                      Option(
                          name: localizations.translate('live_broadcasting'),
                          value: RoomStatus.live),
                      Option(
                          name: localizations.translate('live_preview'),
                          value: RoomStatus.notStarted),
                    ],
                    defaultValue: liveListController.status.value,
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          )
        ],
      );
    },
  );
}
