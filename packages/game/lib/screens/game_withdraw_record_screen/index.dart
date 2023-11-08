import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/index.dart';
import 'package:game/widgets/modal_dropdown.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../localization/game_localization_delegate.dart';

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
    final GameLocalizations localizations = GameLocalizations.of(context)!;
    Map<int, String> status = {
      1: localizations.translate('reviewing'),
      2: localizations.translate('failed_to_withdraw'),
      3: localizations.translate('completed'),
    };
    if (type == 0) return const SizedBox();
    return Container(
      height: 28,
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: status[type] == localizations.translate('completed')
              ? withdrawalSuccess
              : withdrawalFelid,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          status[type] ?? '',
          style: TextStyle(
            color: status[type] == localizations.translate('completed')
                ? withdrawalSuccess
                : status[type] == localizations.translate('failed_to_withdraw')
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
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    Map<int, String> remittanceType = {
      1: localizations.translate('bank_card'),
      2: 'USDT',
    };

    return Scaffold(
      appBar: AppBar(
        backgroundColor: gameLobbyBgColor,
        centerTitle: true,
        title: Text(
          localizations.translate('withdrawal_history'),
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
                          title: localizations.translate('type'),
                          onChange: (value) => fetchDataByCondition(
                            name: 'remittanceType',
                            value: value,
                          ),
                          items: [
                            {
                              'value': 1,
                              'label': localizations.translate('bank_card'),
                            },
                            const {
                              'value': 2,
                              'label': 'USDT',
                            }
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: ModalDropDown(
                          title: localizations.translate('status'),
                          onChange: (value) => fetchDataByCondition(
                            name: 'status',
                            value: value,
                          ),
                          items: [
                            {
                              'value': 1,
                              'label': localizations.translate('reviewing'),
                            },
                            {
                              'value': 2,
                              'label':
                                  localizations.translate('failed_to_withdraw'),
                            },
                            {
                              'value': 3,
                              'label': localizations.translate('completed'),
                            }
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: ModalDropDown(
                          title: localizations
                              .translate('application_time_enquiry'),
                          onChange: (value) => fetchDataByCondition(
                            name: 'auditDate',
                            value: value,
                          ),
                          isLast: true,
                          items: [
                            {
                              'value': 1,
                              'label': localizations.translate('today'),
                            },
                            {
                              'value': 2,
                              'label': localizations.translate('yesterday'),
                            },
                            {
                              'value': 3,
                              'label': localizations.translate('last_7_days'),
                            },
                            {
                              'value': 4,
                              'label': localizations.translate('last_30_days'),
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
                          Text(
                            localizations.translate('no_record'),
                            style: const TextStyle(color: Color(0xFF979797)),
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
                        RowItem(
                            title:
                                localizations.translate('withdrawal_account'),
                            value: item.account),
                        RowItem(
                            title: localizations.translate('withdrawal_amount'),
                            value: item.applyAmount),
                        RowItem(
                          title: localizations.translate('application_time'),
                          value: parseDateTime(item.auditDate),
                        ),
                        RowItem(
                          title: localizations.translate('update_time'),
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
