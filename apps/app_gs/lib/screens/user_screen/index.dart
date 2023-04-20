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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                padding: const EdgeInsets.only(bottom: 90),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0xFF79A2C8),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      '版本號:3.8.7533967',
                      style: TextStyle(color: Color(0xFF79A2C8)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MediaQuery.of(context).padding.bottom)
