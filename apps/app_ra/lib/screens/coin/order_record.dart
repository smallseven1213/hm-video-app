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
  String dropdownValue = option.first['value'];

  @override
  Widget build(BuildContext context) {
    print('@@@dropdownValue: ${option}');

    return Container(
      height: 33,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        dropdownColor:
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.85),
        iconSize: 20,
        icon:
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
        style: const TextStyle(fontSize: 12, color: Colors.white),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
          widget.onChanged!(value!);
        },
        items: option.map<DropdownMenuItem<String>>((Map option) {
          return DropdownMenuItem<String>(
            value: option['value'],
            child: Text(option['name']),
          );
        }).toList(),
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
        Align(
          alignment: Alignment.centerRight,
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
        Expanded(
          child: UserOrderRecordConsumer(
              key: Key('order-record-$chargeType'),
              type: chargeType,
              child: (List<Order> records) {
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
                );
              }),
        ),
      ],
    );
  }
}
