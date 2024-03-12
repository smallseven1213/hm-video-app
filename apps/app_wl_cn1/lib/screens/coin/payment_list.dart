import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:shared/apis/orders_api.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/modules/user/user_payment_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:url_launcher/url_launcher.dart';

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
  PaymentListState createState() => PaymentListState();
}

class PaymentListState extends State<PaymentList> {
  int? selectedId;
  String? selectedType;
  bool isLoading = false;

  sendOrder(context, {required int paymentChannelId}) async {
    try {
      setState(() => isLoading = true);
      var res = await orderApi.makeOrder(
        productId: widget.productId,
        paymentChannelId: paymentChannelId,
      );

      if (!mounted) return;
      var paymentLink = res['data']['paymentLink'];
      if (res.isNotEmpty && paymentLink.startsWith('http')) {
        if (GetPlatform.isWeb) {
          await Future.delayed(const Duration(milliseconds: 500));
          setState(() => isLoading = false);
          Navigator.pop(context);
          launchUrl(Uri.parse(paymentLink), webOnlyWindowName: '_blank');
          MyRouteDelegate.of(context).push(AppRoutes.orderConfirm);
        } else {
          await launchUrl(Uri.parse(paymentLink), webOnlyWindowName: '_blank');
          setState(() => isLoading = false);
          Navigator.pop(context);
          MyRouteDelegate.of(context).push(AppRoutes.orderConfirm);
        }
      } else {
        setState(() => isLoading = false);
        showConfirmDialog(
          context: context,
          title: '付款錯誤',
          message: res['message'],
          showCancelButton: false,
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      }
    } catch (error) {
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
                    const Text('請選擇支付方式',
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '已選擇 ${widget.name}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.amount.toString(),
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xFFc91e1e)),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    payments.isEmpty
                        ? const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                '無可用支付方式',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: payments.length,
                              itemBuilder: (context, index) {
                                final payment = payments[index];
                                final bool isSelected =
                                    payment.id == selectedId;
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
                                              ? const Color(0xFFb5925c)
                                              : const Color(0xFFd8d6de)),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: payment.iconSid != null
                                              ? SidImage(sid: payment.iconSid!)
                                              : Container(),
                                        ),
                                        // width 10
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: Text(
                                          payment.type.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        )),
                                        if (isSelected)
                                          Container(
                                            width: 16,
                                            height: 16,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFb5925c),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 5,
                                                  spreadRadius: 2,
                                                  offset: Offset(0, 0),
                                                ),
                                              ],
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          selectedId == null || isLoading
                              ? const Color(0xFFd8d6de)
                              : const Color(0xFFb5925c),
                        ),
                        // 移除 fixedSize，使用 minimumSize 來設置最小高度，寬度將自動擴展
                        minimumSize: MaterialStateProperty.all(
                            const Size(double.infinity, 40)),
                      ),
                      onPressed: () {
                        if (selectedId == null || isLoading) return;
                        sendOrder(
                          context,
                          paymentChannelId: selectedId ?? 0,
                        );
                      },
                      child: const Text('確認支付',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                if (isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ));
      },
    );
  }
}
