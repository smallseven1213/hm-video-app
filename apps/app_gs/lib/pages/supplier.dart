import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_video_controller.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../screens/supplier/card.dart';
import '../screens/supplier/list.dart';
import '../widgets/list_no_more.dart';
import '../widgets/no_data.dart';
import '../widgets/sliver_video_preview_skelton_list.dart';

// class SupplierPage extends StatelessWidget {
//   final int id;

//   const SupplierPage({
//     Key? key,
//     required this.id,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final ScrollController scrollController = ScrollController();
// final vodController = SupplierVodController(
//     supplierId: id, scrollController: scrollController);
//     return Scaffold(
//       body: Stack(
//         children: [
//           Obx(() => CustomScrollView(
//                 controller: vodController.scrollController,
//                 physics: const BouncingScrollPhysics(),
//                 slivers: [
//                   SliverToBoxAdapter(
//                     child: SizedBox(
//                       height: MediaQuery.of(context).padding.top,
//                     ),
//                   ),
//                   SupplierCard(id: id),
//                   SupplierVods(id: id, vodList: vodController.vodList),
//                   if (vodController.hasMoreData.value)
//                     SliverVideoPreviewSkeletonList(),
//                   if (!vodController.hasMoreData.value)
//                     SliverToBoxAdapter(
//                       child: ListNoMore(),
//                     )
//                 ],
//               )),
//           const FloatPageBackButton()
//         ],
//       ),
//     );
//   }
// }
// wrap to staetfull widget, and keepAlive set to true

class SupplierPage extends StatefulWidget {
  final int id;

  const SupplierPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController scrollController = ScrollController();
  late final SupplierVideoController vodController;

  @override
  void initState() {
    super.initState();
    vodController = SupplierVideoController(
        supplierId: widget.id, scrollController: scrollController);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => CustomScrollView(
                controller: vodController.scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                  ),
                  SupplierCard(id: widget.id),
                  SupplierVods(id: widget.id, vodList: vodController.vodList),
                  if (vodController.isListEmpty.value)
                    const SliverToBoxAdapter(
                      child: NoDataWidget(),
                    ),
                  if (vodController.displayLoading.value)
                    // ignore: prefer_const_constructors
                    SliverVideoPreviewSkeletonList(),
                  if (vodController.displayNoMoreData.value)
                    SliverToBoxAdapter(
                      child: ListNoMore(),
                    )
                ],
              )),
          const FloatPageBackButton()
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
