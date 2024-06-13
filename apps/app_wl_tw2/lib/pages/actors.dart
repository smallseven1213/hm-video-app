import 'package:app_wl_tw2/config/colors.dart';
import 'package:app_wl_tw2/widgets/custom_app_bar.dart';
import 'package:app_wl_tw2/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/actor_region_controller.dart';
import 'package:shared/controllers/actors_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/navigator/delegate.dart';

import '../screens/actors/tabbar.dart';
import '../widgets/circle_sidimage_text_item.dart';
import '../widgets/no_data.dart';

final logger = Logger();

class ActorsPage extends StatefulWidget {
  const ActorsPage({Key? key}) : super(key: key);
  @override
  ActorsPageState createState() => ActorsPageState();
}

class ActorsPageState extends State<ActorsPage> with TickerProviderStateMixin {
  late ActorsController actorsController;
  late ActorRegionController actorRegionController;

  @override
  void initState() {
    super.initState();
    actorRegionController = Get.find<ActorRegionController>();
    actorsController = Get.put(ActorsController(fetchWhenInit: false));

    actorRegionController.regions.listen((regions) {
      if (regions.isNotEmpty) {
        actorsController.setRegion(regions[0].id);
      }
    });
  }

  Widget _buildCustomRadioButton(int value, String label) {
    return Expanded(
        flex: 1,
        child: GestureDetector(
            onTap: () {
              actorsController.setSortBy(value);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.colors[ColorKeys.secondary],
                      ),
                    ),
                    Positioned(
                      top: 1,
                      left: 1,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.colors[ColorKeys.secondary],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    Obx(() {
                      if (actorsController.sortBy.value == value) {
                        return const Icon(
                          Icons.check,
                          size: 15,
                          color: Colors.white,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    })
                  ],
                ),
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.colors[ColorKeys.textPrimary]),
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '全部女優',
      ),
      body: Column(
        children: [
          const ActorsTabBar(),
          Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  flex: 1,
                  child: SearchInput(
                    placeHolder: '輸入名稱',
                    backgroundColor:
                        AppColors.colors[ColorKeys.formBg] as Color,
                    onSubmitted: (val) {
                      actorsController.setName(val);
                    },
                    onChanged: (val) {
                      if (val.isEmpty) {
                        actorsController.setName('');
                      }
                    },
                  )),
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text(
                          '排序',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.colors[ColorKeys.textPrimary]),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          _buildCustomRadioButton(0, '視頻'),
                          _buildCustomRadioButton(1, '人氣'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(child: Obx(() {
            if (actorsController.actors.isEmpty) {
              return const Center(
                child: NoDataWidget(),
              );
            }
            return AlignedGridView.count(
                crossAxisCount: 5,
                itemCount: actorsController.actors.length,
                itemBuilder: (context, actorIndex) {
                  var actor = actorsController.actors[actorIndex];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        MyRouteDelegate.of(context).push(
                          AppRoutes.actor,
                          args: {
                            'id': actor.id,
                            'title': actor.name,
                          },
                          removeSamePath: true,
                        );
                      },
                      child: CircleTextItem(
                        text: actor.name,
                        photoSid: actor.photoSid,
                        imageWidth: 60,
                        imageHeight: 60,
                        isRounded: true,
                        hasBorder: true,
                      ),
                    ),
                  );
                });
          }))
        ],
      ),
    );
  }
}
