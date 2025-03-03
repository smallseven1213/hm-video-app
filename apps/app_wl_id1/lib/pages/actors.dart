import 'package:app_wl_id1/localization/i18n.dart';
import 'package:app_wl_id1/widgets/custom_app_bar.dart';
import 'package:app_wl_id1/widgets/no_data.dart';
import 'package:app_wl_id1/widgets/search_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/actor_region_controller.dart';
import 'package:shared/controllers/actors_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../screens/actors/tabbar.dart';
import '../widgets/circle_sidimage_text_item.dart';

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
    if (Get.isRegistered<ActorsController>()) {
      actorsController = Get.find<ActorsController>();
      actorsController.name.value = '';
    } else {
      actorsController = Get.put(ActorsController());
      actorRegionController.regions.listen((regions) {
        if (regions.isNotEmpty) {
          actorsController.setRegion(regions[0].id);
        }
      });
    }
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
                        borderRadius: kIsWeb ? null : BorderRadius.circular(8),
                        // border: Border.all(
                        //   color: Colors.black.withOpacity(0.5),
                        //   width: 1,
                        // ),
                        gradient: kIsWeb
                            ? null
                            : const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF00B2FF),
                                  Color(0xFFCCEAFF),
                                  Color(0xFF00B2FF),
                                ],
                              ),
                      ),
                    ),
                    Positioned(
                      top: 1,
                      left: 1,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF002865),
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
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: I18n.allFemaleActors),
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
                    placeHolder: I18n.inputName,
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
                          I18n.sort,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          _buildCustomRadioButton(0, I18n.video),
                          _buildCustomRadioButton(1, I18n.popularity),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Expanded(child: Obx(() {
            if (actorsController.actors.isEmpty) {
              return const Center(
                child: NoDataWidget(),
              );
            }
            return AlignedGridView.count(
                crossAxisCount: 4,
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
                        maxLines: 1,
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
