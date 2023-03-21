// ListMenu, 有widgets/Header, 然後ListItem是靜態列表
// ListTile都有onTap事件

import 'package:flutter/material.dart';

import '../../widgets/header.dart';

class ListMenu extends StatelessWidget {
  const ListMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            children: [
              const Header(text: 'hi'),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.ac_unit),
                    title: Text('Menu $index'),
                  );
                },
              ),
            ],
          );
        },
        childCount: 1,
      ),
    );
  }
}
