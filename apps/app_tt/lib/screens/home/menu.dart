import 'package:flutter/material.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/modules/user_setting/user_setting_quick_link_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../widgets/id_card.dart';
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
              if (item.name == '身份卡') {
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
            children: menuItems,
          ),
        );
      },
    );
  }
}
