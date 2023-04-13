import 'package:app_gp/utils/showConfirmDialog.dart';
import 'package:flutter/material.dart';

class ListMenuItem {
  final String name;
  final String icon;
  final Function onTap;

  ListMenuItem({
    required this.name,
    required this.icon,
    required this.onTap,
  });
}

class ListMenu extends StatelessWidget {
  const ListMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      ListMenuItem(
        name: '找回帳號',
        icon: 'assets/images/user_screen_find_account.png',
        onTap: () {
          showConfirmDialog(
              context: context,
              title: '提示',
              message: '請使用手機應用程式找回帳號',
              showCancelButton: false);
        },
      ),
      ListMenuItem(
        name: '版本號:3003.8.92',
        icon: 'assets/images/user_screen_version.png',
        onTap: () {},
      ),
    ];
    return SliverList(
      delegate: SliverChildListDelegate(
        items.map((item) {
          return Container(
            height: 38,
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(38),
              border: Border.all(
                color: const Color(0xFF8594E2),
                width: 1,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF000916),
                  Color(0xFF003F6C),
                ],
                stops: [0.0, 1.0],
              ),
            ),
            child: InkWell(
              onTap: item.onTap as void Function()?,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 16),
                  Image(
                    image: AssetImage(item.icon),
                    width: 17,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
