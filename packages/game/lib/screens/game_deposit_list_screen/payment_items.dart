import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:game/screens/game_deposit_list_screen/OliveShapeClipper.dart';
import 'package:game/screens/game_deposit_list_screen/amount_form.dart';
import 'package:game/screens/game_deposit_list_screen/confirm_name.dart';
import 'package:game/screens/game_deposit_list_screen/confirm_pin.dart';
import 'package:game/screens/game_deposit_list_screen/showUserName.dart';
import 'package:game/screens/game_deposit_list_screen/title.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/showModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
  final Map depositData;
  final String initialIndex;
  const DepositPaymentItems(
      {Key? key, required this.depositData, required this.initialIndex})
      : super(key: key);

  @override
  State<DepositPaymentItems> createState() => _DepositPaymentItemsState();
}

var paymentsMapper = {
  'aliPay': {
    'title': '支付寶',
    'icon': 'packages/game/assets/images/game_deposit/aliPay.webp',
  },
  'debit': {
    'title': '銀行卡',
    'icon': 'packages/game/assets/images/game_deposit/debit.webp',
  },
  'unionPay': {
    'title': '雲閃付',
    'icon': 'packages/game/assets/images/game_deposit/unionPay.webp',
  },
  'weChat': {
    'title': '微信',
    'icon': 'packages/game/assets/images/game_deposit/weChat.webp',
  },
};

var depositAmountType = {
  'showInput': 1,
  'noInput': 2,
};

class _DepositPaymentItemsState extends State<DepositPaymentItems> {
  String _paymentActiveIndex = '';
  int _channelActiveIndex = 0;
  int _amountActiveIndex = 0;
  final amountController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  final theme = themeMode[GetStorage().hasData('pageColor')
          ? GetStorage().read('pageColor')
          : 1]
      .toString();

  @override
  void initState() {
    super.initState();
    _paymentActiveIndex = widget.initialIndex;
    setInitFormValue();
  }

  void setInitFormValue() {
    if (widget.depositData[_paymentActiveIndex].length > 0 &&
        widget.depositData[_paymentActiveIndex][_channelActiveIndex]
                ['amountType'] ==
            depositAmountType['showInput']) {
      amountController.text = widget.depositData[_paymentActiveIndex]
              [_channelActiveIndex]['minAmount']
          .toString();
    }
  }

  void paymentIndexChanged(idx) async {
    setState(() {
      _paymentActiveIndex = idx;
      _channelActiveIndex = 0;
      _amountActiveIndex = 0;

      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        setInitFormValue();
      });
    });
  }

  void channelIndexChanged(idx) {
    setState(() {
      _channelActiveIndex = idx;
      _amountActiveIndex = 0;

      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        setInitFormValue();
      });
    });
  }

  void amountIndexChanged(idx) {
    setState(() {
      _amountActiveIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = themeMode[GetStorage().hasData('pageColor')
            ? GetStorage().read('pageColor')
            : 1]
        .toString();
    List paymentItem = widget.depositData.keys.toList();
    int paymentLength = paymentItem.isNotEmpty ? paymentItem.length.toInt() : 0;

    List channels = List.from(widget.depositData[_paymentActiveIndex]);
    int channelLength = channels.isNotEmpty ? channels.length.toInt() : 0;
    num channelHeight =
        (channelLength > 3 ? (channelLength / 3).ceil() * 54 : 60);

    int amountLength = channels.isNotEmpty &&
            channels[_channelActiveIndex]['specificAmounts'] != null
        ? channels[_channelActiveIndex]['specificAmounts'].length
        : 0;

    num amountHeight = amountLength > 4 ? (amountLength / 4).ceil() * 80 : 80;

    print(
        '======indexssss======: $_paymentActiveIndex, $_channelActiveIndex, $_amountActiveIndex');

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
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
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  paymentItem.length,
                  (index) => GestureDetector(
                      onTap: () {
                        paymentIndexChanged(paymentItem[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: Container(
                          width: Get.width / paymentLength - 18,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: _paymentActiveIndex == paymentItem[index]
                                ? gameLobbyDepositActiveColor
                                : gameItemMainColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _paymentActiveIndex == paymentItem[index]
                                  ? gamePrimaryButtonColor
                                  : gameItemMainColor,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                paymentsMapper[paymentItem[index]] != null
                                    ? paymentsMapper[paymentItem[index]]![
                                            'icon']
                                        .toString()
                                    : 'packages/game/assets/images/game_lobby/game_empty-$theme.webp',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                paymentsMapper[paymentItem[index]] != null
                                    ? paymentsMapper[paymentItem[index]]![
                                            'title']
                                        .toString()
                                    : widget.depositData.keys.toList()[index],
                                style: TextStyle(
                                  color: gameLobbyPrimaryTextColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                      const DepositTitle(
                        title: '支付渠道',
                      ),
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
                                                    channels[index]['name']
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
                                              if (channels[index]
                                                      ['isRecommend'] ==
                                                  true)
                                                const Positioned(
                                                    top: -10,
                                                    left: -5,
                                                    child: OliveShape())
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
                          '沒有支付通道',
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
                  const DepositTitle(
                    title: '存款金額',
                  ),
                  if (channels[_channelActiveIndex]['amountType'] ==
                          depositAmountType['showInput'] &&
                      channels[_channelActiveIndex]['maxAmount'] != null &&
                      channels[_channelActiveIndex]['minAmount'] != null)
                    AmountForm(
                      formKey: _formKey,
                      controller: amountController,
                      max:
                          channels[_channelActiveIndex]['maxAmount'].toDouble(),
                      min:
                          channels[_channelActiveIndex]['minAmount'].toDouble(),
                      activePayment: _paymentActiveIndex,
                      paymentChannelId:
                          channels[_channelActiveIndex]['id'].toString(),
                    ),

                  if (channels[_channelActiveIndex]['specificAmounts'] != null)
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
                                amountIndexChanged(index);
                                if (channels[_channelActiveIndex]
                                        ['amountType'] ==
                                    depositAmountType['noInput']) {
                                  if (_paymentActiveIndex == 'debit') {
                                    print('銀行卡');
                                    showUserName(
                                      context,
                                      onSuccess: (userName) {
                                        showModel(
                                          context,
                                          content: ConfirmName(
                                            amount:
                                                channels[_channelActiveIndex]
                                                            ['specificAmounts']
                                                        [index]
                                                    .toString(),
                                            paymentChannelId:
                                                channels[_channelActiveIndex]
                                                        ['id']
                                                    .toString(),
                                            activePayment: _paymentActiveIndex,
                                          ),
                                          onClosed: () =>
                                              Navigator.pop(context),
                                        );
                                      },
                                    );
                                  } else {
                                    print('no input && no bank card');
                                    showModel(
                                      context,
                                      content: ConfirmPin(
                                        amount: channels[_channelActiveIndex]
                                                ['specificAmounts'][index]
                                            .toString(),
                                        paymentChannelId:
                                            channels[_channelActiveIndex]['id']
                                                .toString(),
                                        activePayment:
                                            _paymentActiveIndex.toString(),
                                      ),
                                      onClosed: () => Navigator.pop(context),
                                    );
                                  }
                                } else {
                                  // 將金額帶入amountController
                                  amountController.text =
                                      channels[_channelActiveIndex]
                                              ['specificAmounts'][index]
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
                                    '${channels[_channelActiveIndex]['specificAmounts'][index].toString()}元',
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
