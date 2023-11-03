import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/index.dart';
import 'package:game/widgets/modal_dropdown.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

const remittanceType = {
  1: '銀行卡',
  2: 'USDT',
};

const status = {
  1: '審核中',
  2: '出款失敗',
  3: '已完成',
};

const auditDate = {
  1: '今天',
  2: '昨天',
  3: '近七天',
  4: '近三十天',
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

final logger = Logger();

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
          color: status[type] == '已完成' ? withdrawalSuccess : withdrawalFelid,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          status[type] ?? '',
          style: TextStyle(
            color: status[type] == '已完成'
                ? withdrawalSuccess
                : status[type] == '出款失敗'
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
    // logger.i('RowItem build: $title, $value');
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

class GameWithdrawRecord extends StatefulWidget {
  const GameWithdrawRecord({Key? key}) : super(key: key);

  @override
  State<GameWithdrawRecord> createState() => _GameWithdrawRecordState();
}

class _GameWithdrawRecordState extends State<GameWithdrawRecord> {
  final gamePlatformProvider = Get.find<GameLobbyApi>();
  List record = [];
  Map condition = {};

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    await gamePlatformProvider.getWithdrawalRecord().then((value) {
      setState(() {
        record = value;
      });
    });
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
    await gamePlatformProvider
        .getWithdrawalRecord(
      remittanceType: condition['remittanceType'],
      status: condition['status'],
      startedAt:
          condition['startDate'] != null ? condition['startDate'] + 'Z' : null,
      endedAt: condition['endDate'] != null ? condition['endDate'] + 'Z' : null,
    )
        .then((value) {
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
    logger.i('record: $record');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gameLobbyBgColor,
        centerTitle: true,
        title: Text(
          '提現紀錄',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: gameLobbyAppBarTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: gameLobbyAppBarIconColor),
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
                          title: '類型',
                          onChange: (value) => fetchDataByCondition(
                            name: 'remittanceType',
                            value: value,
                          ),
                          items: const [
                            {
                              'value': 1,
                              'label': '銀行卡',
                            },
                            {
                              'value': 2,
                              'label': 'USDT',
                            }
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: ModalDropDown(
                          title: '狀態',
                          onChange: (value) => fetchDataByCondition(
                            name: 'status',
                            value: value,
                          ),
                          items: const [
                            {
                              'value': 1,
                              'label': '審核中',
                            },
                            {
                              'value': 2,
                              'label': '出款失敗',
                            },
                            {
                              'value': 3,
                              'label': '已完成',
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
                      children: [
                        Row(
                          children: [
                            Text(
                              remittanceType[item.remittanceType] ?? '',
                              style:
                                  TextStyle(color: gameLobbyPrimaryTextColor),
                            ),
                            const Spacer(),
                            StatusLabel(
                              type: item.status ?? 0,
                            ),
                          ],
                        ),
                        Divider(color: gameLobbyDividerColor),
                        RowItem(title: '提款帳戶', value: item.account),
                        RowItem(title: '提款金額', value: item.applyAmount),
                        RowItem(
                          title: '申請時間',
                          value: parseDateTime(item.auditDate),
                        ),
                        RowItem(
                          title: '更新時間',
                          value: parseDateTime(item.updatedAt),
                        ),
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
