import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/user.dart';
import 'package:shared/models/user_purchase_record.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/user/user_purchase_record_consumer.dart';

final logger = Logger();

class PurchaseRecord extends StatelessWidget {
  const PurchaseRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return UserInfoConsumer(
      child: (User info, isVIP, isGuest) {
        if (info.id.isEmpty) {
          return const SizedBox();
        }
        return UserPurchaseRecordConsumer(
          userId: info.id,
          child: (List<UserPurchaseRecord> result) => ListView.builder(
            itemCount: result.length,
            itemBuilder: (context, index) {
              final record = result[index];
              return Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      record.createdAt!.replaceAll(' ', '\n'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 22),
                    Expanded(
                      child: Text(
                        record.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(width: 22),
                    Text(
                      '\$${record.usedPoints ?? ''}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
