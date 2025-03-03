import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_core/widgets/live_image.dart';
import 'package:live_core/controllers/live_search_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../../localization/live_localization_delegate.dart';
import '../../widgets/no_result.dart';

class SearchResults extends StatelessWidget {
  final LiveSearchController controller = Get.find();
  final LiveListController liveListController = Get.find();

  SearchResults({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    return Obx(() {
      var steamer = controller.searchResult;
      if (steamer.isEmpty) {
        return const Center(child: NoResult());
      }
      return ListView.builder(
        itemCount: steamer.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              width: 50,
              height: 50,
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25)),
              child: LiveImage(
                base64Url: steamer[index].avatar ?? '',
              ),
            ),
            title: Text(
              steamer[index].nickname,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '${localizations.translate('number_of_followers')}: ${steamer[index].fansCount}',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white),
            onTap: () {
              final room =
                  liveListController.getRoomByStreamerId(steamer[index].id);
              if (room == null) {
                MyRouteDelegate.of(context).push(
                  AppRoutes.supplier,
                  args: {
                    'id': steamer[index].supplierId,
                  },
                );
              } else {
                MyRouteDelegate.of(context).push(
                  "/live_room",
                  args: {"pid": room.id},
                );
              }
            },
          );
        },
      );
    });
  }
}
