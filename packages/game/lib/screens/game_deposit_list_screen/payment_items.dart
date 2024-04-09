import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:game/models/game_deposit_payment_type_list.dart';
import 'package:game/models/game_payment_channel_detail.dart';
import 'package:game/screens/game_deposit_list_screen/olive_shape_clipper.dart';
import 'package:game/screens/game_deposit_list_screen/amount_form.dart';
import 'package:game/screens/game_deposit_list_screen/confirm_name.dart';
import 'package:game/screens/game_deposit_list_screen/confirm_pin.dart';
import 'package:game/screens/game_deposit_list_screen/show_user_name.dart';
import 'package:game/screens/game_deposit_list_screen/title.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/show_model.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/enums/game_app_routes.dart';

import 'package:shared/navigator/delegate.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class DepositPaymentItems extends StatefulWidget {
  final List<DepositPaymentTypeList> paymentList;
  final Map depositData;
  final String initialIndex;
  const DepositPaymentItems(
      {Key? key,
      required this.paymentList,
      required this.depositData,
      required this.initialIndex})
      : super(key: key);

  @override
  State<DepositPaymentItems> createState() => _DepositPaymentItemsState();
}

var depositAmountType = {
  'showInput': 1,
  'noInput': 2,
};

class _DepositPaymentItemsState extends State<DepositPaymentItems> {
  String _paymentActiveIndex = '';
  int _channelActiveIndex = 0;
  final amountController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  final theme = themeMode[GetStorage().hasData('pageColor')
          ? GetStorage().read('pageColor')
          : 1]
      .toString();
  final gameWithdrawController = Get.put(GameWithdrawController());
  ScrollController scrollController = ScrollController();
  GlobalKey scrollKey = GlobalKey();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _paymentActiveIndex = widget.depositData.containsKey(widget.initialIndex)
        ? widget.initialIndex
        : widget.depositData.keys.first;

    setInitFormValue();
  }

  // dispose
  @override
  void dispose() {
    amountController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void setInitFormValue() {
    if (widget.depositData[_paymentActiveIndex].length > 0 &&
        widget.depositData[_paymentActiveIndex][_channelActiveIndex]
                .amountType ==
            depositAmountType['showInput']) {
      amountController.text = widget
          .depositData[_paymentActiveIndex][_channelActiveIndex].minAmount
          .toString();
    }
  }

  void paymentIndexChanged(idx) async {
    setState(() {
      _paymentActiveIndex = idx;
      _channelActiveIndex = 0;

      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        setInitFormValue();
      });
    });
  }

  void channelIndexChanged(idx) {
    setState(() {
      _channelActiveIndex = idx;

      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        setInitFormValue();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;
    final theme = themeMode[GetStorage().hasData('pageColor')
            ? GetStorage().read('pageColor')
            : 1]
        .toString();

    List paymentItem = widget.paymentList.where((element) {
      final depositDataKeys = widget.depositData.keys.toList();
      return depositDataKeys.contains(element.code);
    }).toList();

    int paymentLength = paymentItem.isNotEmpty ? paymentItem.length.toInt() : 0;
    List channels = List.from(widget.depositData[_paymentActiveIndex]);
    int channelLength = channels.isNotEmpty ? channels.length.toInt() : 0;
    num channelHeight =
        (channelLength > 3 ? (channelLength / 3).ceil() * 54 : 60);
    int amountLength = channels.isNotEmpty &&
            channels[_channelActiveIndex].specificAmounts != null
        ? channels[_channelActiveIndex].specificAmounts.length
        : 0;
    num amountHeight = amountLength > 4 ? (amountLength / 4).ceil() * 80 : 80;

    logger.i("active 支付類型: $_paymentActiveIndex");
    logger.i("active 支付渠道: ${channels[_channelActiveIndex].name}");

    handleAmount(index) {
      gameWithdrawController.setDepositAmount(
          channels[_channelActiveIndex].specificAmounts[index]);
      if (channels[_channelActiveIndex].amountType ==
          depositAmountType['noInput']) {
        if (widget.depositData[_paymentActiveIndex][_channelActiveIndex]
                .requireName ==
            0) {
          logger.i('確認真實姓名');
          showUserName(
            context,
            onSuccess: (userName) {
              showModel(
                context,
                title: localizations.translate('order_confirmation'),
                content: ConfirmName(
                  amount: channels[_channelActiveIndex]
                      .specificAmounts[index]
                      .toString(),
                  paymentChannelId: channels[_channelActiveIndex].id.toString(),
                  activePayment: _paymentActiveIndex,
                ),
                onClosed: () => Navigator.pop(context),
              );
            },
          );
        } else if (_paymentActiveIndex == 'selfdebit' ||
            _paymentActiveIndex == 'selfusdt') {
          var paymentChannelId = channels[_channelActiveIndex].id;
          MyRouteDelegate.of(context).push(
            GameAppRoutes.depositDetail,
            args: {
              'payment': _paymentActiveIndex,
              'paymentChannelId': paymentChannelId,
            },
          );
        } else {
          logger.i('確認pin');
          showModel(
            context,
            title: localizations.translate('order_confirmation'),
            content: ConfirmPin(
              amount: channels[_channelActiveIndex]
                  .specificAmounts[index]
                  .toString(),
              paymentChannelId: channels[_channelActiveIndex].id.toString(),
              activePayment: _paymentActiveIndex.toString(),
            ),
            onClosed: () => Navigator.pop(context),
          );
        }
      } else {
        // 將金額帶入amountController
        amountController.text =
            channels[_channelActiveIndex].specificAmounts[index].toString();
      }
    }

    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: gameItemMainColor,
          borderRadius: BorderRadius.circular(24),
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
            // ======支付方式======
            SingleChildScrollView(
              key: scrollKey,
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 5,
                children: List.generate(
                  paymentItem.length,
                  (index) => GestureDetector(
                      onTap: () {
                        paymentIndexChanged(paymentItem[index].code);
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
                                color: _paymentActiveIndex ==
                                        paymentItem[index].code
                                    ? gameLobbyDepositActiveColor
                                    : gameItemMainColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _paymentActiveIndex ==
                                          paymentItem[index].code
                                      ? gamePrimaryButtonColor
                                      : gameItemMainColor,
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  paymentItem[index] != null
                                      ? Image.network(
                                          paymentItem[index].icon,
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
                                    paymentItem[index].name.toString(),
                                    style: TextStyle(
                                      color: gameLobbyPrimaryTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (paymentItem[index].label.length > 0)
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
            ),
            SizedBox(
              height: 40,
              child: Divider(
                color: gameLobbyDividerColor,
                thickness: 1,
              ),
            ),
            // ======支付渠道======
            (widget.depositData[_paymentActiveIndex].isNotEmpty &&
                    channels.isNotEmpty)
                ? Column(
                    children: [
                      DepositTitle(
                          title: localizations.translate('payment_channel')),
                      SizedBox(
                        height: channelHeight.toDouble(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GridView.builder(
                            itemCount: channelLength,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              mainAxisExtent: 38,
                            ),
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  if (_channelActiveIndex ==
                                      index) // active 右下角三角形
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: RotatedBox(
                                        quarterTurns: 1,
                                        child: ClipPath(
                                          clipper: CustomTriangleClipper(),
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: gamePrimaryButtonColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_channelActiveIndex ==
                                      index) // active 右下角打勾icon
                                    Positioned(
                                      right: 1,
                                      bottom: 1,
                                      child: Icon(
                                        Icons.check,
                                        color: gamePrimaryButtonTextColor,
                                        size: 12,
                                      ),
                                    ),
                                  GestureDetector(
                                    onTap: () {
                                      channelIndexChanged(index);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 45,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 6, 10, 8),
                                                decoration: BoxDecoration(
                                                  color: _channelActiveIndex ==
                                                          index
                                                      ? gameLobbyDepositActiveColor
                                                      : gameItemMainColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.fromBorderSide(
                                                    BorderSide(
                                                      color: _channelActiveIndex ==
                                                              index
                                                          ? gamePrimaryButtonColor
                                                          : gameLobbyLoginFormBorderColor,
                                                      width: 1,
                                                    ),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    channels[index]
                                                        .name
                                                        .toString(),
                                                    style: TextStyle(
                                                      color:
                                                          gameSecondButtonTextColor,
                                                      fontSize: 12,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (double.parse(channels[index]
                                                      .discountRatio) >
                                                  0.00)
                                                Positioned(
                                                  top: -1,
                                                  right: -1,
                                                  child: OliveShape(
                                                    type: 'right',
                                                    bgColor:
                                                        const LinearGradient(
                                                      colors: [
                                                        Color(0xFFFF00B8),
                                                        Color(0xFFFF00B8)
                                                      ],
                                                    ),
                                                    text:
                                                        '送${channels[index].discountRatio.toString()}%',
                                                  ),
                                                ),
                                              if (channels[index].tag != null &&
                                                  channels[index].tag != 0)
                                                Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: OliveShape(
                                                    width: 28,
                                                    bgColor: depositChannelLabel[
                                                            channels[index]
                                                                .tag]!['color']
                                                        as LinearGradient,
                                                    text: depositChannelLabel[
                                                            channels[index]
                                                                .tag]!['text']
                                                        .toString(),
                                                  ),
                                                )
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox(
                    width: 110,
                    height: 160,
                    child: Center(
                        child: Column(
                      children: [
                        Image.asset(
                          'packages/game/assets/images/game_deposit/payment_empty-$theme.webp',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localizations.translate('no_payment_channel'),
                          style: TextStyle(color: gameLobbyPrimaryTextColor),
                        ),
                      ],
                    )),
                  ),
            // ======存款金額======
            if (widget.depositData[_paymentActiveIndex].isNotEmpty &&
                channels.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: Divider(
                      color: gameLobbyDividerColor,
                      thickness: 1,
                    ),
                  ),
                  // 存款金額
                  DepositTitle(
                    title: localizations.translate('deposit_amount'),
                  ),
                  if (channels[_channelActiveIndex].amountType ==
                          depositAmountType['showInput'] &&
                      channels[_channelActiveIndex].maxAmount != null &&
                      channels[_channelActiveIndex].minAmount != null)
                    AmountForm(
                      formKey: _formKey,
                      controller: amountController,
                      focusNode: focusNode,
                      max: channels[_channelActiveIndex].maxAmount.toDouble(),
                      min: channels[_channelActiveIndex].minAmount.toDouble(),
                      activePayment: _paymentActiveIndex,
                      paymentChannelId:
                          channels[_channelActiveIndex].id.toString(),
                    ),

                  if (channels[_channelActiveIndex].specificAmounts != null)
                    SizedBox(
                      height: amountHeight.toDouble(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GridView.builder(
                          itemCount: amountLength,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent:
                                60, // here set custom Height You Want
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                handleAmount(index);
                              },
                              child: Container(
                                height: 55,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: gameItemMainColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: gameLobbyLoginFormBorderColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${channels[_channelActiveIndex].specificAmounts[index].toString()}${localizations.translate('dollar')}',
                                    style: TextStyle(
                                      color: gamePrimaryButtonColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                ],
              )
          ],
        ),
      ),
    );
  }
}
