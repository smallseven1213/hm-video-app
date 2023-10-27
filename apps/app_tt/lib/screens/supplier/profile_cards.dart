import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/suppliers_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/supplier.dart';
import 'package:shared/modules/user/user_favorites_supplier_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import '../../widgets/actor/follow_button.dart';
import '../../widgets/actor_avatar.dart';

class ProfileCards extends StatefulWidget {
  const ProfileCards({super.key});

  @override
  _ProfileCardsState createState() => _ProfileCardsState();
}

class _ProfileCardsState extends State<ProfileCards> {
  bool isDeleting = false;
  late SuppliersController suppliersController;

  @override
  void initState() {
    super.initState();
    suppliersController = Get.put(SuppliersController(
      initialIsRecommend: true,
      initialLimit: 20,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Supplier> suppliers = suppliersController.actors;
      return SizedBox(
        width: double.infinity,
        height: suppliers.isEmpty ? 30 : 200,
        child: suppliers.isEmpty
            ? const Text('暫時沒有更多了', textAlign: TextAlign.center)
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: suppliers.length,
                itemBuilder: (context, index) {
                  return profileCard(
                    suppliers[index].photoSid ?? '',
                    suppliers[index].name ?? '',
                    suppliers[index].id ?? 0,
                    supplier: suppliers[index],
                    onDelete: () {
                      suppliersController.removeSupplierByIndex(index);
                    },
                  );
                },
              ),
      );
    });
  }

  Widget profileCard(String photoSid, String name, int id,
      {supplier, Function()? onDelete}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Card(
            elevation: 5,
            child: Container(
              width: 162,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => MyRouteDelegate.of(context).push(
                      AppRoutes.supplier,
                      args: {'id': supplier.id, 'title': supplier.name},
                      removeSamePath: true,
                    ),
                    child: ActorAvatar(
                        width: 100, height: 100, photoSid: photoSid),
                  ),
                  const SizedBox(height: 8),
                  Text(name,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  UserFavoritesSupplierConsumer(
                    id: id,
                    info: supplier,
                    child: (isLiked, handleLike) => InkWell(
                      onTap: handleLike,
                      child: FollowButton(isLiked: isLiked),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}
