import 'package:app_ra/screens/coin/no_data.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/user_order.dart';
import 'package:shared/modules/user/user_order_record_consumer.dart';

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
    return Column(
      children: [
        Stack(alignment: Alignment.topRight, children: [
          Positioned(
            child: CustomDropdownMenu(
              onChanged: (String? value) {
                logger.i(value);
                setState(() {
                  chargeType = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          UserOrderRecordConsumer(
              key: Key('order-record-$chargeType'),
              type: chargeType,
              child: (List<Order> records) {
                if (records.isEmpty) return const NoData();
                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.product!.name ?? '',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '\$ ${record.orderAmount}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '訂單時間 ${record.createdAt}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '訂單編號 ${record.id}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Text(
                            record.paymentStatus == 0 ? '成功' : '失敗',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
        ]),
      ],
    );
  }
}
