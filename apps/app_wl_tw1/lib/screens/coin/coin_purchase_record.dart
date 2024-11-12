import 'package:app_wl_tw1/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/user.dart';
import 'package:shared/models/user_purchase_record.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/user/user_purchase_record_consumer.dart';

final logger = Logger();

class CoinPurchaseRecord extends StatefulWidget {
  const CoinPurchaseRecord({super.key});

  @override
  CoinPurchaseRecordState createState() => CoinPurchaseRecordState();
}

class CoinPurchaseRecordState extends State<CoinPurchaseRecord> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff1c202f),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: UserInfoConsumer(
        child: (User info, isVIP, isGuest, isLoading) {
          if (info.id.isEmpty) {
            return const SizedBox();
          }
          return UserPurchaseRecordConsumer(
            userId: info.id,
            child: (List<UserPurchaseRecord> records) {
              if (records.isEmpty) {
                return const NoDataWidget();
              }
              return ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  List<String> parts = record.createdAt!.split(' ');
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(122, 145, 155, 179),
                            width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 16, top: 16),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              parts[0],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              parts[1],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              record.name ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        Text(
                          record.usedPoints ?? '',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
