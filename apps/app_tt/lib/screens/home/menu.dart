import 'package:flutter/material.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/modules/user_setting/user_setting_quick_link_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';

import 'menu_item.dart';

class UserMenuWidget extends StatelessWidget {
  const UserMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserSettingQuickLinkConsumer(
      child: (List<Navigation> quickLinks) {
        var menuItems = quickLinks.map((Navigation item) {
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
              MyRouteDelegate.of(context).push(item.path ?? '');
            },
          );
        }).toList();
        return Container(
          width: 235,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 48),
          child: ListView(
            children: menuItems,
          ),
        );
      },
    );
  }
}
