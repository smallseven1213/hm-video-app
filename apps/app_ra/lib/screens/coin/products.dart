import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/modules/user/user_product_consumer.dart';

final logger = Logger();

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
          return Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${product.discount}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text('\$原價: ${product.fiatMoneyPrice}',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
