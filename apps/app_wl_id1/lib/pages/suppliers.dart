import 'package:app_wl_id1/localization/i18n.dart';
import 'package:app_wl_id1/widgets/custom_app_bar.dart';
import 'package:app_wl_id1/widgets/no_data.dart';
import 'package:app_wl_id1/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/suppliers_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import '../widgets/circle_sidimage_text_item.dart';

final logger = Logger();

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({Key? key}) : super(key: key);
  @override
  SuppliersPageState createState() => SuppliersPageState();
}

class SuppliersPageState extends State<SuppliersPage>
    with TickerProviderStateMixin {
  late SuppliersController suppliersController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<SuppliersController>()) {
      suppliersController = Get.find<SuppliersController>();
      suppliersController.setName('');
    } else {
      suppliersController = Get.put(SuppliersController());
    }
  }

  Widget _buildCustomRadioButton(int value, String label) {
    return Expanded(
        flex: 1,
        child: GestureDetector(
            onTap: () {
              suppliersController.setSortBy(value);
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
                      if (suppliersController.sortBy.value == value) {
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
      appBar: CustomAppBar(
        title: I18n.allCreators,
      ),
      body: Column(
        children: [
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
                      suppliersController.setName(val);
                    },
                    onChanged: (val) {
                      if (val.isEmpty) {
                        suppliersController.setName('');
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
                          _buildCustomRadioButton(1, I18n.video),
                          _buildCustomRadioButton(2, I18n.popularity),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Expanded(child: Obx(() {
            if (suppliersController.actors.isEmpty) {
              return const Center(
                child: NoDataWidget(),
              );
            }
            return AlignedGridView.count(
                crossAxisCount: 4,
                itemCount: suppliersController.actors.length,
                itemBuilder: (context, actorIndex) {
                  var actor = suppliersController.actors[actorIndex];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        MyRouteDelegate.of(context).push(
                          AppRoutes.supplier,
                          args: {
                            'id': actor.id,
                          },
                          removeSamePath: true,
                        );
                      },
                      child: CircleTextItem(
                        text: actor.name ?? '',
                        photoSid: actor.photoSid ?? '',
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
