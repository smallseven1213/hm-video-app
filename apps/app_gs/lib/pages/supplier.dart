import 'package:flutter/material.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../screens/supplier/card.dart';
import '../screens/supplier/list.dart';

class SupplierPage extends StatelessWidget {
  final int id;

  const SupplierPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController parentScrollController = ScrollController();
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
            ),
            SupplierCard(id: id),
            SupplierVods(id: id, scrollController: parentScrollController)
          ],
        ),
        const FloatPageBackButton()
      ],
    );
  }
}
