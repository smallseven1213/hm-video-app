import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_core/widgets/live_image.dart';
import 'package:live_core/controllers/live_search_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

class KeywordList extends StatelessWidget {
  final Function(String)? onSearch;
  final LiveSearchController controller = Get.find();

  KeywordList({
    Key? key,
    this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: controller.recommendKeywords.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              onSearch!(controller.recommendKeywords[index]);
            },
            title: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xff7b7b7b)),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        color: Color(0xffc2c3c4), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      controller.recommendKeywords[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}

class SearchResults extends StatelessWidget {
  final LiveSearchController controller = Get.find();
  final LiveListController liveListController = Get.find();

  SearchResults({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var steamer = controller.searchResult;
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
              '粉絲人數: ${steamer[index].fansCount}',
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
                    'id': steamer[index].id,
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
