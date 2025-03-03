import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/system_config_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/modules/user_setting/user_setting_more_link_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/id_card.dart';
import 'menu_item.dart';

class UserMenuWidget extends StatelessWidget {
  const UserMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final systemConfigController = Get.find<SystemConfigController>();
    return UserSettingMoreLinkConsumer(
      child: (List<Navigation> moreLinks) {
        var menuItems = moreLinks.map((Navigation item) {
          return MenuItem(
            icon: item.photoSid != null
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
          );
        }).toList();
        return Container(
          width: 235,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 48),
          child: ListView(
            children: [
              ...menuItems,
              MenuItem(
                icon: const Icon(
                  Icons.language,
                  size: 22,
                ),
                text: '切換語系',
                onTap: () {
                  MyRouteDelegate.of(context).push(AppRoutes.demo);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
