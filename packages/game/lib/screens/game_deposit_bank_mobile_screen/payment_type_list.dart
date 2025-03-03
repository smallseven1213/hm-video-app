import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class DepositPaymentTypeListWidget extends StatefulWidget {
  final String paymentActiveIndex;
  final List paymentListItem;
  final Function handlePaymentIndexChanged;
  const DepositPaymentTypeListWidget({
    Key? key,
    required this.paymentActiveIndex,
    required this.paymentListItem,
    required this.handlePaymentIndexChanged,
  }) : super(key: key);

  @override
  State<DepositPaymentTypeListWidget> createState() =>
      _DepositPaymentTypeListWidgetState();
}

class _DepositPaymentTypeListWidgetState
    extends State<DepositPaymentTypeListWidget> {
  GlobalKey scrollKey = GlobalKey();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  // dispose
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = themeMode[GetStorage().hasData('pageColor')
            ? GetStorage().read('pageColor')
            : 1]
        .toString();

    int paymentLength = widget.paymentListItem.isNotEmpty
        ? widget.paymentListItem.length.toInt()
        : 0;

    logger.i("transfer bank active 支付類型: ${widget.paymentActiveIndex}");

    return SingleChildScrollView(
      key: scrollKey,
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width - 70),
        child: Wrap(
          spacing: 5,
          alignment: WrapAlignment.start,
          children: List.generate(
            widget.paymentListItem.length,
            (index) => GestureDetector(
              onTap: () {
                widget.handlePaymentIndexChanged(
                    widget.paymentListItem[index]['code']);
                final double scrollOffset = index * 45 -
                    MediaQuery.of(context).size.width / 2 +
                    MediaQuery.of(context).size.width / 4;
                scrollController.animateTo(
                  index >= 4 ? scrollOffset : 0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Container(
                      width: paymentLength <= 4
                          ? MediaQuery.of(context).size.width / 4 - 12
                          : MediaQuery.of(context).size.width / 4 - 22,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: widget.paymentActiveIndex ==
                                widget.paymentListItem[index]['code']
                                    .toLowerCase()
                            ? gameLobbyDepositActiveColor
                            : gameItemMainColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.paymentActiveIndex ==
                                  widget.paymentListItem[index]['code']
                                      .toLowerCase()
                              ? gamePrimaryButtonColor
                              : gameItemMainColor,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            widget.paymentListItem[index] != null
                                ? widget.paymentListItem[index]['icon']
                                : 'packages/game/assets/images/game_deposit/payment_empty-$theme.webp',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.paymentListItem[index]['name'].toString(),
                            style: TextStyle(
                              color: gameLobbyPrimaryTextColor,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
