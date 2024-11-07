import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/apis/orders_api.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/modules/user/user_payment_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../localization/i18n.dart';
import '../../utils/show_confirm_dialog.dart';
import '../../widgets/button.dart';

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

  Future<void> sendOrder(BuildContext context,
      {required int paymentChannelId}) async {
    try {
      setState(() => isLoading = true);
      var res = await orderApi.makeOrder(
        productId: widget.productId,
        paymentChannelId: paymentChannelId,
      );

      if (!mounted) return;
      _handlePaymentResponse(context, res);
    } catch (error) {
      _showErrorDialog(context, I18n.paymentError, I18n.paymentError);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _handlePaymentResponse(BuildContext context, dynamic res) async {
    if (res.isNotEmpty && res['code'] == '00') {
      var paymentLink = res['data']['paymentLink'];
      if (paymentLink.startsWith('http')) {
        // await launchUrl(
        //     Uri.parse(paymentLink),
        //     webOnlyWindowName: '_blank');
        MyRouteDelegate.of(context)
            .push(AppRoutes.orderConfirm, args: {'paymentLink': paymentLink});
      }
    } else {
      _showErrorDialog(context, I18n.paymentError, res['message']);
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showConfirmDialog(
      context: context,
      title: title,
      message: message,
      showCancelButton: false,
      onConfirm: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaymentConsumer(
      id: widget.productId,
      child: (payments) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: payments.isEmpty ? 250 : 350,
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(context),
                  _buildSelectedProductInfo(),
                  payments.isEmpty
                      ? _buildEmptyPaymentMessage()
                      : _buildPaymentList(payments),
                  _buildConfirmButton(),
                ],
              ),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      I18n.pleaseSelectPaymentMethod,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Widget _buildSelectedProductInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${I18n.selected} ${widget.name} ',
              style: const TextStyle(fontSize: 12.0, color: Colors.white),
            ),
            TextSpan(
              text: '\$${widget.amount}',
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPaymentMessage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          I18n.noAvailablePaymentMethod,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildPaymentList(List payments) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          final bool isSelected = payment.id == selectedId;
          return PaymentOption(
            payment: payment,
            isSelected: isSelected,
            onSelect: () {
              setState(() {
                selectedId = payment.id;
                selectedType = payment.type;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      child: Button(
        text: I18n.confirm,
        type: selectedId == null || isLoading ? 'cancel' : 'primary',
        onPressed: () {
          if (selectedId == null || isLoading) return;
          sendOrder(context, paymentChannelId: selectedId ?? 0);
        },
      ),
    );
  }
}

class PaymentOption extends StatelessWidget {
  final dynamic payment;
  final bool isSelected;
  final VoidCallback onSelect;

  const PaymentOption({
    Key? key,
    required this.payment,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isSelected ? const Color(0xFF464c61) : const Color(0xFF21263d),
        ),
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            SidImage(
              sid: '${payment.iconSid}',
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 8),
            Text(
              payment.type.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            _buildSelectionIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            shape: BoxShape.circle,
          ),
          width: 12,
          height: 12,
        ),
        Icon(
          size: 16,
          isSelected ? Icons.check_circle : Icons.circle_outlined,
          color: isSelected ? const Color(0xff6874b6) : const Color(0xff919bb3),
        ),
      ],
    );
  }
}
