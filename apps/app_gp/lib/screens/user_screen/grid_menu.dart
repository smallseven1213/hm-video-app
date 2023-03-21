// GridMenu is a stateless widget, 是 一列4個的網格菜單
// 資料是靜態
// 每一個網格是一個 InkWell, 有 onTap 事件
// 內容是上方一個Icon, 下方是置中的文字

import 'package:flutter/material.dart';

class GridMenu extends StatelessWidget {
  const GridMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        // mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return InkWell(
            onTap: () {},
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.ac_unit),
                  const SizedBox(height: 5),
                  Text(
                    'Menu $index',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: 8,
      ),
    );
  }
}
