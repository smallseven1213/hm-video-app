import 'package:app_ra/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:shared/apis/orders_api.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/modules/user/user_payment_consumer.dart';
import 'package:shared/navigator/delegate.dart';

import '../../utils/show_confirm_dialog.dart';

final orderApi = OrderApi();

class PaymentList extends StatefulWidget {
  final int productId;
  final double amount;
  final String? name;

  const PaymentList({
    Key? key,
    required this.productId,
    required this.amount,
    this.name,
  }) : super(key: key);

  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  int? selectedId;
  String? selectedType;
  bool isLoading = false;

  sendOrder({required int paymentChannelId}) async {
    print('sandOrder');
    print('paymentChannelId: $paymentChannelId');
    try {
      setState(() {
        isLoading = true;
      });
      var res = await orderApi.makeOrder(
        productId: widget.productId,
        paymentChannelId: paymentChannelId,
      );

      print('res: $res');
      if (!mounted) return;
      if (res['code'] != '00') {
        showConfirmDialog(
          context: context,
          title: '付款錯誤',
          message: res['message'],
          showCancelButton: false,
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        MyRouteDelegate.of(context).push(AppRoutes.orderConfirm);
      }
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
      showConfirmDialog(
        context: context,
        title: '付款錯誤',
        message: '付款錯誤',
        showCancelButton: false,
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PaymentConsumer(
      id: widget.productId,
      child: (payments) {
        return Container(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Column(
                  children: [
                    Text('請選擇支付方式',
                        style: Theme.of(context).textTheme.headlineLarge),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        '已選擇 ${widget.name} \$${widget.amount}',
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final payment = payments[index];
                          final bool isSelected = payment.id == selectedId;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedId = payment.id;
                                selectedType = payment.type;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.white),
                                borderRadius: BorderRadius.circular(8),
                                color:
                                    isSelected ? const Color(0xFF273262) : null,
                              ),
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                payment.type.toString(),
                                style: TextStyle(
                                    color: isSelected
                                        ? Theme.of(context).primaryColor
                                        : Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Button(
                            text: '取消',
                            type: isLoading ? 'disabled' : 'cancel',
                            size: 'small',
                            onPressed: () {
                              if (isLoading) return;
                              setState(() {
                                selectedId = null;
                                selectedType = null;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 80,
                          child: Button(
                            text: '確認',
                            size: 'small',
                            type: selectedId == null || isLoading
                                ? 'disabled'
                                : 'primary',
                            onPressed: () {
                              if (isLoading) return;
                              sendOrder(paymentChannelId: selectedId ?? 0);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                if (isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ));
      },
    );
  }
}
