import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:game/controllers/game_withdraw_controller.dart';
import 'package:game/models/game_deposit_payment_type_list.dart';
import 'package:game/models/game_payment_channel_detail.dart';
import 'package:game/screens/game_deposit_list_screen/olive_shape_clipper.dart';
import 'package:game/screens/game_deposit_list_screen/payment_type_list.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/handel_submit_amount.dart';
import 'package:game/widgets/deposit_amount_form.dart';
import 'package:game/widgets/deposit_title.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

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
      _paymentActiveIndex = idx.toLowerCase();
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

    List<DepositPaymentTypeList> paymentListItem =
        widget.paymentList.where((element) {
      final depositDataKeys = widget.depositData.keys.toList();
      return depositDataKeys.contains(element.code.toLowerCase());
    }).toList();

    List channels =
        List.from(widget.depositData[_paymentActiveIndex.toLowerCase()]);
    int channelLength = channels.isNotEmpty ? channels.length.toInt() : 0;
    num channelHeight =
        (channelLength > 3 ? (channelLength / 3).ceil() * 54 : 60);
    int amountLength = channels.isNotEmpty &&
            channels[_channelActiveIndex].specificAmounts != null
        ? channels[_channelActiveIndex].specificAmounts.length
        : 0;
    num amountHeight = amountLength > 4 ? (amountLength / 4).ceil() * 80 : 80;
    bool requireName = paymentListItem
            .firstWhere((element) =>
                element.code.toLowerCase() == _paymentActiveIndex.toLowerCase())
            .requireName
            .toString()
            .contains('0')
        ? false // NO
        : true; // YES
    bool requirePhone = paymentListItem
            .firstWhere((element) =>
                element.code.toLowerCase() == _paymentActiveIndex.toLowerCase())
            .requirePhone
            .toString()
            .contains('0')
        ? false
        : true;

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
            DepositPaymentTypeListWidget(
              paymentActiveIndex: _paymentActiveIndex.toLowerCase(),
              paymentListItem: paymentListItem,
              handlePaymentIndexChanged: paymentIndexChanged,
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
                  if (channels[_channelActiveIndex].maxAmount != null &&
                      channels[_channelActiveIndex].minAmount != null)
                    AmountForm(
                      formKey: _formKey,
                      controller: amountController,
                      focusNode: focusNode,
                      max: channels[_channelActiveIndex].maxAmount.toDouble(),
                      min: channels[_channelActiveIndex].minAmount.toDouble(),
                      activePayment: _paymentActiveIndex.toLowerCase(),
                      paymentChannelId:
                          channels[_channelActiveIndex].id.toString(),
                      requireName: requireName,
                      requirePhone: requirePhone,
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
                                gameWithdrawController.setDepositAmount(
                                    channels[_channelActiveIndex]
                                        .specificAmounts[index]);
                                if (channels[_channelActiveIndex].amountType ==
                                    depositAmountType['noInput']) {
                                  handleSubmitAmount(
                                    context,
                                    enableSubmit: true,
                                    controller: amountController,
                                    activePayment:
                                        _paymentActiveIndex.toLowerCase(),
                                    paymentChannelId:
                                        channels[_channelActiveIndex]
                                            .id
                                            .toString(),
                                    requireName: requireName,
                                    requirePhone: requirePhone,
                                    focusNode: focusNode,
                                  );
                                } else {
                                  amountController.text =
                                      channels[_channelActiveIndex]
                                          .specificAmounts[index]
                                          .toString();
                                }
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
