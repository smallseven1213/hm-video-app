import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/user_order.dart';
import 'package:shared/modules/user/user_order_record_consumer.dart';

import '../../widgets/no_data.dart';

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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            option.firstWhere((e) => e['value'] == _selectedValue)['name'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(Icons.keyboard_arrow_down_rounded,
              size: 16, color: Colors.white),
        ),
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => setState(() => isMenuOpen = !isMenuOpen),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xff464c61),
            ),
            child: selectedOption,
          ),
        ),
        if (isMenuOpen)
          Container(
            width: 120,
            decoration: BoxDecoration(
              color: const Color(0xff464c61),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: option.map((e) {
                return InkWell(
                  onTap: () => setState(() {
                    isMenuOpen = false;
                    _selectedValue = e['value'];
                    if (widget.onChanged != null) {
                      widget.onChanged!(e['value']!);
                    }
                  }),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      e['name']!,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 12,
                        color: _selectedValue == e['value']
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class OrderRecord extends StatefulWidget {
  const OrderRecord({super.key});

  @override
  OrderRecordState createState() => OrderRecordState();
}

class OrderRecordState extends State<OrderRecord> {
  final ScrollController _scrollController = ScrollController();
  bool showNoMore = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // 當滾動到達底部時
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      //todo 載入更多or沒有更多
    }
  }

  Widget statusContainer(String text, Color color) {
    return Container(
      alignment: Alignment.center,
      width: 60,
      height: 22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget paymentStatus(Order record) {
    switch (record.paymentStatus) {
      case 1:
        return statusContainer('確認中', const Color(0xff464c61));
      case 2:
        return statusContainer('已完成', const Color(0xff2c9b66));
      default:
        return statusContainer('失敗', const Color(0xffe05252));
    }
  }

  String chargeType = option.first['value'];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff1c202f),
      child: Stack(
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
                        if (records.isEmpty) return const NoDataWidget();
                        return ListView.separated(
                          controller: _scrollController,
                          itemCount: records.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              color: Colors.grey.shade200.withOpacity(0.5),
                            );
                          },
                          itemBuilder: (context, index) {
                            final record = records[index];
                            return Container(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '購買商品名稱/支付類型',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '金額：${record.orderAmount}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '訂單時間：${record.createdAt}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff919bb3),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '訂單編號：${record.id}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff919bb3),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  paymentStatus(record),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
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
      ),
    );
  }
}
