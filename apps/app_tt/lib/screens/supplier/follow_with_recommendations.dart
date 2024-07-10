import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_controller.dart';
import 'package:shared/controllers/suppliers_controller.dart';
import 'package:shared/models/supplier.dart';
import 'package:shared/modules/user/user_favorites_supplier_consumer.dart';
import 'profile_cards.dart';

class FollowWithRecommendations extends StatefulWidget {
  final int id;
  final Supplier supplier;

  const FollowWithRecommendations({
    super.key,
    required this.id,
    required this.supplier,
  });

  @override
  FollowWithRecommendationsState createState() =>
      FollowWithRecommendationsState();
}

class FollowWithRecommendationsState extends State<FollowWithRecommendations> {
  late SuppliersController suppliersController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    suppliersController = Get.put(
      SuppliersController(
        initialIsRecommend: true,
        initialLimit: 20,
      ),
      tag: 'actor-${widget.id}',
    );
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        suppliersController.fetchUnfollowedSuppliers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SupplierController supplierController =
        Get.find<SupplierController>(tag: 'supplier-${widget.id}');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: UserFavoritesSupplierConsumer(
                id: widget.id,
                info: widget.supplier,
                actionType: 'collect',
                child: (isLiked, handleLike) => InkWell(
                  onTap: () {
                    handleLike!();
                    if (isLiked) {
                      supplierController.decrementTotal('follow');
                      return;
                    } else {
                      supplierController.incrementTotal('follow');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 36,
                    decoration: BoxDecoration(
                      color: isLiked
                          ? const Color(0xfff1f1f2)
                          : const Color(0xfffe2c55),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isLiked ? '已關注' : '+ 關注',
                      style: TextStyle(
                        fontSize: 13,
                        color: isLiked ? const Color(0xff161823) : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFf1f1f2),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: 36,
              height: 36,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.black,
                  size: 24.0,
                ),
                onPressed: _toggleExpand,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_isExpanded)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '你可能感興趣',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color(0xff73747b), fontSize: 13),
                ),
                const SizedBox(height: 10),
                ProfileCards(id: widget.id)
              ],
            ),
          ),
      ],
    );
  }
}
