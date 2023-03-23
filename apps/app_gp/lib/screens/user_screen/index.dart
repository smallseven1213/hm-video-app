import 'package:flutter/material.dart';

import '../../widgets/header.dart';
import 'ad.dart';
import 'grid_menu.dart';
import 'info.dart';
import 'list_menu.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: const [
                UserInfo(),
                SizedBox(height: 10),
                Ad(),
              ],
            ),
          ),
          GridMenu(),
          const SliverToBoxAdapter(
            child: Header(text: '更多服務'),
          ),
          const ListMenu(),
        ],
      ),
    );
  }
}
