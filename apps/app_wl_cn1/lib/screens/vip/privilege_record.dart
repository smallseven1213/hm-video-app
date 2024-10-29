import 'package:app_wl_cn1/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/user.dart';
import 'package:shared/models/user_privilege_record.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/modules/user/user_privilege_record_consumer.dart';

import '../../localization/i18n.dart';

final logger = Logger();

class PrivilegeRecord extends StatefulWidget {
  const PrivilegeRecord({super.key});

  @override
  PrivilegeRecordState createState() => PrivilegeRecordState();
}

class PrivilegeRecordState extends State<PrivilegeRecord> {
  bool isSwitched = false;

  Widget _buildStatusTag(bool isAvailable) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isAvailable
            ? const Color(0xff2c9b66) // 有效狀態使用綠色
            : const Color(0xffe05252), // 失效狀態使用紅色
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isAvailable ? I18n.valid : I18n.expired,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRecordItem(UserPrivilegeRecord record) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xff2c2f3c), width: 1),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    record.name ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                _buildStatusTag(record.isAvailable!),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${I18n.startTime}${record.createdAt}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff919bb3),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${I18n.validPeriod}${record.vipExpiredAt}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff919bb3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff1c202f),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  I18n.showOnlyValid,
                  style: TextStyle(fontSize: 14, color: Color(0xff919bb3)),
                ),
                const SizedBox(width: 4),
                Checkbox(
                  value: isSwitched,
                  onChanged: (value) => setState(() => isSwitched = value!),
                  activeColor: const Color(0xff919bb3),
                  checkColor: Colors.white,
                  side: const BorderSide(color: Color(0xff919bb3), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: UserInfoConsumer(
              child: (User info, isVIP, isGuest, isLoading) {
                if (info.id.isEmpty) {
                  return const SizedBox();
                }
                return UserPrivilegeRecordConsumer(
                  userId: info.id,
                  child: (List<UserPrivilegeRecord> records) {
                    if (records.isEmpty) {
                      return const NoDataWidget();
                    }

                    List<UserPrivilegeRecord> result = isSwitched
                        ? records
                            .where((record) => record.isAvailable == true)
                            .toList()
                        : records;

                    return ListView.builder(
                      itemCount: result.length,
                      itemBuilder: (context, index) {
                        final record = result[index];
                        return _buildRecordItem(record);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
