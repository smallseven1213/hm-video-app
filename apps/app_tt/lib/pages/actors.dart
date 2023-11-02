import 'package:app_tt/localization/i18n.dart';
import 'package:app_tt/widgets/my_app_bar.dart';
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
    actorsController = Get.put(ActorsController());
    actorRegionController = Get.find<ActorRegionController>();
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
      appBar: const MyAppBar(
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
                  // child: SearchInput(
                  //   placeHolder: '輸入名稱',
                  //   onSubmitted: (val) {
                  //     actorsController.setName(val);
                  //   },
                  //   onChanged: (val) {
                  //     if (val.isEmpty) {
                  //       actorsController.setName('');
                  //     }
                  //   },
                  // )
                  child: Container()),
              Expanded(
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text(
                          '排序',
                          style: TextStyle(fontSize: 12, color: Colors.white),
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
