import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/product.dart';
import 'package:shared/modules/user/user_product_consumer.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../utils/show_modal_bottom_sheet.dart';
import 'payment_list.dart';

final logger = Logger();

Widget _buildProductCard(context, Product product) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      height: 90, // Adjust the height as needed
      child: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFF4D4B4), Color(0xFFDAB385)],
              ),
            ),
          ),
          ClipPath(
            clipper: CustomClipperPath(),
            child: Container(
              color: Colors.black,
              height: 90,
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.description ?? "",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      // vertical center, horizontal align left
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        product.fiatMoneyPrice != null &&
                                product.fiatMoneyPrice!.isNotEmpty
                            ? Text("售價 : ${product.fiatMoneyPrice}",
                                style: const TextStyle(
                                    color: Color(0xFF979698), fontSize: 12))
                            : Container(),
                        const SizedBox(width: 13),
                        const Text("特價 : ",
                            style: TextStyle(
                                color: Color(0xFF979698), fontSize: 12)),
                        Text(product.balanceFiatMoneyPrice ?? "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ],
                    )
                  ],
                ),
              )),
              SizedBox(
                width: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SidImage(
                      sid: product.photoSid!,
                      width: 50,
                      height: 50,
                    ),
                    Text(
                      product.name!,
                      style: TextStyle(color: Color(0xFF632903), fontSize: 15),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  // return Container(
  //   padding: const EdgeInsets.all(20),
  //   margin: const EdgeInsets.only(bottom: 8),
  //   decoration: BoxDecoration(
  //     borderRadius: BorderRadius.circular(8),
  //     border: Border.all(
  //       color: Theme.of(context).colorScheme.primary,
  //     ),
  //   ),
  //   child: Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         product.name ?? '',
  //         style: Theme.of(context).textTheme.headlineLarge,
  //       ),
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         children: [
  //           Text(
  //             '\$${product.discount}',
  //             style: TextStyle(
  //               fontSize: 12,
  //               fontWeight: FontWeight.bold,
  //               color: Theme.of(context).colorScheme.primary,
  //             ),
  //           ),
  //           Text('\$原價: ${product.fiatMoneyPrice}',
  //               style: Theme.of(context).textTheme.bodySmall),
  //         ],
  //       )
  //     ],
  //   ),
  // );
}

class CustomClipperPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Adjust the clip path to create the slanted effect
    path.lineTo(0, size.height);
    path.lineTo(size.width - 160, size.height);
    path.lineTo(size.width - 130, 0);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CoinProducts extends StatelessWidget {
  const CoinProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return ProductConsumer(
      type: ProductType.coin.index,
      child: (products) => ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return GestureDetector(
            onTap: () => showCustomModalBottomSheet(
              context,
              child: PaymentList(
                productId: product.id ?? 0,
                amount: product.discount ?? 0,
                name: product.name,
              ),
            ),
            child: _buildProductCard(context, product),
          );
        },
      ),
    );
  }
}
