// GridMenu is a stateless widget

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/modules/user_setting/user_setting_quick_link_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/id_card.dart';
import 'user_grid_menu_button.dart';

class GridMenu extends StatelessWidget {
  const GridMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final systemConfigController = Get.find<SystemConfigController>();
    return UserSettingQuickLinkConsumer(
      child: (List<Navigation> quickLinks) {
        List<Widget> menuItemsWithSpacing = [];
        quickLinks.asMap().forEach((index, Navigation item) {
          // Add the menu item
          menuItemsWithSpacing.add(
            UserGridMenuButton(
              iconWidget: item.photoSid != null
                  ? SidImage(
                      sid: item.photoSid!,
                      width: 22,
                      height: 22,
                    )
                  : Container(),
              text: item.name ?? '',
              onTap: () {
                if (item.path == '/id') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const Dialog(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        child: IDCard(),
                      );
                    },
                  );
                } else if (item.name == '在線客服') {
                  launchUrl(Uri.parse(
                      '${systemConfigController.apiHost.value}/public/domains/domain/customer-services'));
                } else {
                  MyRouteDelegate.of(context).push(item.path ?? '');
                }
              },
            ),
          );

          if (index != quickLinks.length - 1) {
            menuItemsWithSpacing.add(const SizedBox(width: 50));
          }
        });

        return Row(
          mainAxisAlignment: MainAxisAlignment.center, // 水平居中
          children: menuItemsWithSpacing,
        );
      },
    );
  }
}
