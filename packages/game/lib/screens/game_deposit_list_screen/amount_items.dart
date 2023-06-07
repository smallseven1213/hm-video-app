// AmountItems Widget, 最外是個圓角區間, padding 16
// 裡面有grid樣式的按鈕, 一行有3個按鈕, 行數則不固定, 以api回傳資料為主

import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/models/game_order.dart';
import 'package:game/screens/game_theme_config.dart';

class AmountItems extends StatefulWidget {
  final Function updateLoading;
  const AmountItems({
    Key? key,
    required this.updateLoading,
  }) : super(key: key);

  @override
  AmountItemsState createState() => AmountItemsState();
}

class AmountItemsState extends State<AmountItems> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // a circle graphic, it has back background, and has a border ebfe69
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: gamePrimaryButtonColor,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  "請選擇存款金額",
                  style: TextStyle(
                    color: Color(0xff979797),
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            FutureBuilder<List<Product>>(
              future: GameLobbyApi().getProductManyBy(type: 1),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.55,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: snapshot.data!
                        .map(
                          (e) => TextButton(
                            style: TextButton.styleFrom(
                              // padding y 10
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: gamePrimaryButtonColor,
                                  width: 1,
                                ),
                              ),
                              backgroundColor: gameLobbyDepositActiveColor,
                              // minimumSize: const Size(0, 78),
                            ),
                            onPressed: () {
                              if (!selected) {
                                setState(() {
                                  selected = !selected;
                                });
                                // showGamePaymentMethod(
                                //   context: context,
                                //   productId: e.id ?? 0,
                                //   balanceFiatMoneyPrice:
                                //       e.balanceFiatMoneyPrice ?? '',
                                //   name: e.name ?? '',
                                //   updateLoading: widget.updateLoading,
                                //   onClose: () => setState(() {
                                //     selected = false;
                                //   }),
                                // );
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  e.name.toString(),
                                  style: TextStyle(
                                    color: gamePrimaryButtonColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (e.subTitle != null && e.subTitle != '')
                                  Text(
                                    e.subTitle.toString(),
                                    style: const TextStyle(
                                      color: Color(0xffc7cab6),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ));
  }
}
