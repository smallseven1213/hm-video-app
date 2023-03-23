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
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
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
                    child: ListTile(
                      onTap: () {},
                      leading: const Icon(Icons.ac_unit, color: Colors.white),
                      title: Text(
                        'Menu $index',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
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
