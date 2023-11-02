import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/models/game_order.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/index.dart';
import 'package:game/widgets/modal_dropdown.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../localization/i18n.dart';

final logger = Logger();

Map<int, String> auditDate = {
  1: '今天',
  2: '昨天',
  3: '近七天',
  4: '近三十天',
};

Map<int, String> conditionOrderType = {
  1: '確認中',
  2: I18n.completed,
  3: I18n.failed,
};

Map<int, String> orderType = {
  1: '確認中',
  2: I18n.completed,
  4: I18n.failed,
  5: I18n.failed,
};

DateTime now = DateTime.now();
DateTime midnight = DateTime(now.year, now.month, now.day).toUtc();

enum DateOptionType { today, yesterday, last7Days, last30Days }

final formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS');
final startDateQuery = {
  1: formattedDate.format(midnight),
  2: formattedDate.format(midnight.subtract(const Duration(days: 1))),
  3: formattedDate.format(midnight.subtract(const Duration(days: 7))),
  4: formattedDate.format(midnight.subtract(const Duration(days: 30))),
};

class StatusLabel extends StatelessWidget {
  final int type;
  const StatusLabel({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == 0) return const SizedBox();
    return Container(
      height: 28,
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: conditionOrderType[type] == I18n.completed
              ? withdrawalSuccess
              : withdrawalFelid,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          conditionOrderType[type] ?? '',
          style: TextStyle(
            color: conditionOrderType[type] == I18n.completed
                ? withdrawalSuccess
                : conditionOrderType[type] == I18n.failed
                    ? withdrawalFelid
                    : withdrawalSuccess,
          ),
        ),
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  final String value;
  final String title;

  const RowItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            title,
            style: const TextStyle(color: Color(0xff979797)),
          ),
        ),
        Text(
          value,
          style: TextStyle(color: gameLobbyPrimaryTextColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class GameDepositRecord extends StatefulWidget {
  const GameDepositRecord({Key? key}) : super(key: key);

  @override
  State<GameDepositRecord> createState() => _GameDepositRecordState();
}

class _GameDepositRecordState extends State<GameDepositRecord> {
  List<GameOrder> record = [];
  Map condition = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<List<GameOrder>> fetchData({
    String? startedAt,
    String? endedAt,
    int? paymentStatus,
  }) async {
    Get.find<GameLobbyApi>()
        .getManyBy(
      startedAt: startedAt,
      endedAt: endedAt,
      paymentStatus: paymentStatus,
    )
        .then((value) {
      setState(() {
        record = value;
      });
    });

    return Future.value(record);
  }

  void fetchDataByCondition({name, value}) async {
    setState(() {
      condition[name] = value;
    });

    DateTime endOfDay = value == DateOptionType.yesterday.index + 1
        ? DateTime(now.year, now.month, now.day, 23, 59, 59)
            .subtract(const Duration(days: 1))
            .toUtc()
        : DateTime(now.year, now.month, now.day, 23, 59, 59).toUtc();

    if (name == 'auditDate') {
      condition['startDate'] = startDateQuery[value].toString();
      condition['endDate'] = formattedDate.format(endOfDay).toString();
    }
    await fetchData(
      startedAt:
          condition['startDate'] != null ? condition['startDate'] + 'Z' : null,
      endedAt: condition['endDate'] != null ? condition['endDate'] + 'Z' : null,
      paymentStatus: condition['paymentStatus'],
    ).then((value) {
      setState(() {
        record = value;
      });
    });

    logger.i('condition: $condition, ');
  }

  // 判斷condition['auditDate']return對應的日期
  String getAuditDateText() {
    final formattedDate = DateFormat('yyyy-MM-dd');
    switch (condition['auditDate']) {
      case 1:
        return formattedDate.format(DateTime.now());
      case 2:
        return formattedDate
            .format(DateTime.now().subtract(const Duration(days: 1)));
      case 3:
        return '${formattedDate.format(DateTime.now().subtract(const Duration(days: 7)))} ~ ${formattedDate.format(DateTime.now())}';
      case 4:
        return '${formattedDate.format(DateTime.now().subtract(const Duration(days: 30)))} ~ ${formattedDate.format(DateTime.now())}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gameLobbyBgColor,
        centerTitle: true,
        title: Text(
          I18n.depositHistory,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: gameLobbyAppBarTextColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: gameLobbyAppBarIconColor),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 40,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          color: gameLobbyBgColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: gameLobbyBoxBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ModalDropDown(
                          title: '狀態',
                          onChange: (value) => fetchDataByCondition(
                            name: 'paymentStatus',
                            value: value,
                          ),
                          items: [
                            const {
                              'value': 1,
                              'label': '確認中',
                            },
                            {
                              'value': 2,
                              'label': I18n.completed,
                            },
                            {
                              'value': 3,
                              'label': I18n.failed,
                            }
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: ModalDropDown(
                          title: '申請時間查詢',
                          onChange: (value) => fetchDataByCondition(
                            name: 'auditDate',
                            value: value,
                          ),
                          isLast: true,
                          items: const [
                            {
                              'value': 1,
                              'label': '今天',
                            },
                            {
                              'value': 2,
                              'label': '昨天',
                            },
                            {
                              'value': 3,
                              'label': '近七天',
                            },
                            {
                              'value': 4,
                              'label': '近三十日',
                            },
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (condition['startDate'] != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    heightFactor: 2,
                    child: Text(
                      getAuditDateText(),
                      style: TextStyle(
                        color: gameLobbyPrimaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                if (record.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 120),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'packages/game/assets/images/game_lobby/record-empty-$theme.webp',
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '暫無紀錄',
                            style: TextStyle(color: Color(0xFF979797)),
                          ),
                        ],
                      ),
                    ),
                  ),
                for (var item in record)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: gameItemMainColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, .15),
                          offset: Offset(0, 0),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item.product!.name.toString()} / ${item.paymentType}',
                              style: TextStyle(
                                color: gameLobbyPrimaryTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              width: 80,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color:
                                    orderType[item.paymentStatus] == I18n.failed
                                        ? gameLobbyButtonDisableColor
                                        : Colors.transparent,
                                border: Border.all(
                                  color: orderType[item.paymentStatus] ==
                                          I18n.failed
                                      ? withdrawalFelid
                                      : gameLobbyLoginFormBorderColor,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                orderType[item.paymentStatus].toString(),
                                style: TextStyle(
                                  color: orderType[item.paymentStatus] == '確認中'
                                      ? withdrawalSuccess
                                      : orderType[item.paymentStatus] ==
                                              I18n.completed
                                          ? modalDropDownActive
                                          : gameLobbyButtonDisableTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(color: gameLobbyDividerColor),
                        RowItem(
                          title: '訂單編號',
                          value: item.id.toString(),
                        ),
                        RowItem(
                          title: '訂單時間',
                          value: parseDateTime(item.createdAt.toString()),
                        ),
                        RowItem(
                            title: '金額',
                            value: item.orderAmount!.toStringAsFixed(0)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
