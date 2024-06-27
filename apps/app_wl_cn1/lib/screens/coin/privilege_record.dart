import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/user.dart';
import 'package:shared/models/user_privilege_record.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/user/user_privilege_record_consumer.dart';

import '../../widgets/custom_switch.dart';
import 'no_data.dart';

final logger = Logger();

class PrivilegeRecord extends StatefulWidget {
  const PrivilegeRecord({super.key});

  @override
  PrivilegeRecordState createState() => PrivilegeRecordState();
}

class PrivilegeRecordState extends State<PrivilegeRecord> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              '只顯示有效',
              style: TextStyle(
                fontSize: 12,
                height: .5,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            CustomSwitch(
              value: isSwitched,
              onChanged: (value) => setState(() => isSwitched = value),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child:
              UserInfoConsumer(child: (User info, isVIP, isGuest, isLoading) {
            if (info.id.isEmpty) {
              return const SizedBox();
            }
            return UserPrivilegeRecordConsumer(
                userId: info.id,
                child: (List<UserPrivilegeRecord> records) {
                  if (records.isEmpty) return const NoData();
                  List<UserPrivilegeRecord> result = isSwitched
                      ? records
                          .where((record) => record.isAvailable == true)
                          .toList()
                      : records;
                  return ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      final record = result[index];
                      return Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.name ?? '',
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                Text(
                                  '開始時間 ${record.createdAt}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  '有效時間 ${record.vipExpiredAt}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Text(
                              record.isAvailable! ? '有效' : '已過期',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                });
          }),
        ),
      ],
    );
  }
}
