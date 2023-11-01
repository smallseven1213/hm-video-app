import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared/models/navigation.dart';

import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/controllers/bottom_navigator_controller.dart';

final logger = Logger();

class FloatingButton extends StatefulWidget {
  final bool displayFab;
  final Function onFabTap;
  const FloatingButton(
      {Key? key, required this.displayFab, required this.onFabTap})
      : super(key: key);

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  final localStorage = GetStorage();
  late BottomNavigatorController bottomNavigatorController;
  late Navigation fabLinkData;

  @override
  void initState() {
    super.initState();
    bottomNavigatorController = Get.find<BottomNavigatorController>();
    fabLinkData = bottomNavigatorController.fabLink[0];
  }

  @override
  void dispose() {
    bottomNavigatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15,
      bottom: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => widget.onFabTap(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: FloatingActionButton(
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: () {
                  final path = fabLinkData.path!;
                  final defaultScreenKey =
                      Uri.parse(path).queryParameters['defaultScreenKey'];
                  final routePath = path.substring(0, path.indexOf('?'));

                  MyRouteDelegate.of(context).push(
                    routePath,
                    args: {'defaultScreenKey': '/$defaultScreenKey'},
                  );
                  bottomNavigatorController.changeKey('/$defaultScreenKey');
                },
                child: SidImage(
                  key: ValueKey(fabLinkData.id),
                  sid: fabLinkData.photoSid!,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                )),
          ),
        ],
      ),
    );
  }
}
