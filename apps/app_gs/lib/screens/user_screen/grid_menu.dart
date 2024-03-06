import 'package:app_gs/widgets/id_card.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/modules/user_setting/user_setting_quick_link_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/handle_url.dart';
import 'package:shared/widgets/sid_image.dart';

class GridMenuItem {
  final String name;
  final String icon;
  final Function onTap;

  GridMenuItem({
    required this.name,
    required this.icon,
    required this.onTap,
  });
}

class GridMenu extends StatefulWidget {
  const GridMenu({
    Key? key,
  }) : super(key: key);

  @override
  GridMenuState createState() => GridMenuState();
}

class GridMenuState extends State<GridMenu> {
  @override
  Widget build(BuildContext context) {
    return UserSettingQuickLinkConsumer(
      child: (List<Navigation> quickLinks) {
        var menuItems = quickLinks.map((Navigation item) {
          if (item.path == '/id') {
            return GridMenuItem(
              name: item.name ?? '',
              icon: item.photoSid ?? '',
              onTap: () {
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
              },
            );
          }
          return GridMenuItem(
            name: item.name ?? '',
            icon: item.photoSid ?? '',
            onTap: () {
              if (item.path!.startsWith('http://') ||
                  item.path!.startsWith('https://')) {
                handleHttpUrl(item.path!);
              } else {
                MyRouteDelegate.of(context).push(item.path ?? '');
              }
            },
          );
        }).toList();
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              var item = menuItems[index];
              return GestureDetector(
                onTap: item.onTap as void Function()?,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SidImage(
                        sid: item.icon,
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.name,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: menuItems.length,
          ),
        );
      },
    );
  }
}
