import 'package:flutter/material.dart';
import 'package:shared/modules/products/product_consumer.dart';

import '../widgets/my_app_bar.dart';

class VipPage extends StatelessWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'VIP',
      ),
      body: Container(
          padding: const EdgeInsets.all(8),
          child: ProductConsumer(
            type: 2,
            child: (products) {
              print('products: $products');
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(product.photoSid ?? ''),
                    ),
                    title: Text(product.name ?? ''),
                    subtitle: Text(product.subTitle ?? ''),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('原價: ${product.fiatMoneyPrice}',
                            style: const TextStyle(color: Colors.white)),
                        Text('實際售價: ${product.discount}',
                            style: const TextStyle(color: Colors.white)),
                        Text('description: ${product.description}',
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
