import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/user_order.dart';
import 'package:shared/modules/user/user_order_record_consumer.dart';

import 'no_data.dart';

final logger = Logger();

const List<Map> option = <Map>[
  {
    'name': '全部',
    'value': '',
  },
  {
    'name': '金幣',
    'value': '1',
  },
  {
    'name': 'VIP',
    'value': '2',
  }
];

class CustomDropdownMenu extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const CustomDropdownMenu({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  String? _selectedValue = "";
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    Widget selectedOption = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          option.firstWhere((e) => e['value'] == _selectedValue)['name'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        const Icon(Icons.keyboard_arrow_down_rounded,
            size: 16, color: Colors.white),
      ],
    );

    return InkWell(
      onTap: () => setState(() => isMenuOpen = !isMenuOpen),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        width: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: isMenuOpen
            ? Column(
                children: [
                  selectedOption,
                  ...option.map(
                    (e) => InkWell(
                      onTap: () => setState(() {
                        isMenuOpen = !isMenuOpen;
                        _selectedValue = e['value'];
                        widget.onChanged!(e['value']!);
                      }),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          e['name'],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            color: _selectedValue == e['value']
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : selectedOption,
      ),
    );
  }
}

class OrderRecord extends StatefulWidget {
  const OrderRecord({super.key});

  @override
  _OrderRecordState createState() => _OrderRecordState();
}

class _OrderRecordState extends State<OrderRecord> {
  String chargeType = option.first['value'];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50), // 調整padding來避免重疊
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: UserOrderRecordConsumer(
                    key: Key('order-record-$chargeType'),
                    type: chargeType,
                    child: (List<Order> records) {
                      if (records.isEmpty) return const NoData();
                      return ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final record = records[index];
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  // vertical align top
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          record.product!.name ?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '金額 : ${record.orderAmount}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '訂單時間 ${record.createdAt}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '訂單編號 ${record.id}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                    StatusLabel(
                                      status: record.paymentStatus ?? 0,
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: Color(0xFFd8d6de),
                              ),
                            ],
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: CustomDropdownMenu(
            onChanged: (String? value) {
              logger.i(value);
              setState(() {
                chargeType = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}

class StatusLabel extends StatelessWidget {
  final int status;

  const StatusLabel({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String text;
    Color fontColor;

    switch (status) {
      case 1:
        backgroundColor = const Color(0xFFf8f8f8);
        fontColor = Colors.black;
        text = '確認中';
        break;
      case 2:
        backgroundColor = const Color(0xFF3ca948);
        fontColor = Colors.white;
        text = '已完成';
        break;
      default:
        backgroundColor = const Color(0xFFc91e1e);
        fontColor = Colors.white;
        text = '失敗';
        break;
    }

    return Container(
      width: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: fontColor,
        ),
      ),
    );
  }
}
