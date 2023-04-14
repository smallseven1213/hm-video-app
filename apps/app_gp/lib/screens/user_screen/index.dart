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
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
          ),
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
          // size h 10
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          const ListMenu(),
        ],
      ),
    );
  }
}
