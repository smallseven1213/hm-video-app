import 'package:app_gs/widgets/custom_app_bar.dart';
import 'package:app_gs/widgets/no_data.dart';
import 'package:app_gs/widgets/search_input.dart';
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
    actorsController = Get.put(ActorsController());
    actorRegionController = Get.find<ActorRegionController>();
  }

  Widget _buildCustomRadioButton(int value, String label) {
    return Expanded(
        flex: 1,
        child: InkWell(
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
                        // border: Border.all(
                        //   color: Colors.black.withOpacity(0.5),
                        //   width: 1,
                        // ),
                        gradient: const LinearGradient(
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
                    onSubmitted: (val) {
                      actorsController.setName(val);
                    },
                  )),
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
                    child: InkWell(
                      onTap: () {
                        MyRouteDelegate.of(context).push(
                          AppRoutes.actor.value,
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
