import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:game/models/game_deposit_payment_type_list.dart';
import 'package:game/screens/game_deposit_list_screen/olive_shape_clipper.dart';
import 'package:game/screens/game_theme_config.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();

class DepositPaymentTypeListWidget extends StatefulWidget {
  final String paymentActiveIndex;
  final List<DepositPaymentTypeList> paymentListItem;
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
    final GameLocalizations localizations = GameLocalizations.of(context)!;
    final theme = themeMode[GetStorage().hasData('pageColor')
            ? GetStorage().read('pageColor')
            : 1]
        .toString();

    int paymentLength = widget.paymentListItem.isNotEmpty
        ? widget.paymentListItem.length.toInt()
        : 0;

    logger.i("active 支付類型: ${widget.paymentActiveIndex}");

    return SingleChildScrollView(
      key: scrollKey,
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 5,
        children: List.generate(
          widget.paymentListItem.length,
          (index) => GestureDetector(
              onTap: () {
                widget.handlePaymentIndexChanged(
                    widget.paymentListItem[index].code);
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
                          ? MediaQuery.of(context).size.width / 4 - 22
                          : MediaQuery.of(context).size.width / 4 - 32,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: widget.paymentActiveIndex ==
                                widget.paymentListItem[index].code
                            ? gameLobbyDepositActiveColor
                            : gameItemMainColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.paymentActiveIndex ==
                                  widget.paymentListItem[index].code
                              ? gamePrimaryButtonColor
                              : gameItemMainColor,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.paymentListItem[index] != null
                              ? Image.network(
                                  widget.paymentListItem[index].icon,
                                  width: 24,
                                  height: 24,
                                )
                              : Image.asset(
                                  'packages/game/assets/images/game_deposit/payment_empty-$theme.webp',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                ),
                          const SizedBox(height: 6),
                          Text(
                            widget.paymentListItem[index].name.toString(),
                            style: TextStyle(
                              color: gameLobbyPrimaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.paymentListItem[index].label.isNotEmpty)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: OliveShape(
                        width: 40.0,
                        type: 'right',
                        text: localizations.translate('send_offer'),
                      ),
                    )
                ],
              )),
        ),
      ),
    );
  }
}
