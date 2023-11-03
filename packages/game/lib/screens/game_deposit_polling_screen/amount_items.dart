import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/screens/game_deposit_polling_screen/show_payment_method.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/loading.dart';

final GameLobbyApi gameLobbyApi = GameLobbyApi();

class AmountItems extends StatefulWidget {
  const AmountItems({Key? key}) : super(key: key);

  @override
  AmountItemsState createState() => AmountItemsState();
}

class AmountItemsState extends State<AmountItems> {
  bool selected = false;
  late Future<List<int>> amountFuture;

  @override
  void initState() {
    super.initState();
    amountFuture = gameLobbyApi.getAmount();
  }

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
                Text(
                  I18n.pleaseSelectDepositAmount,
                  style: const TextStyle(
                    color: Color(0xff979797),
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            FutureBuilder<List<int>>(
              future: amountFuture,
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
                                showPaymentMethod(
                                  context: context,
                                  amount: e,
                                  onClose: () => setState(() {
                                    selected = false;
                                  }),
                                );
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '$e 元',
                                  style: TextStyle(
                                    color: gamePrimaryButtonColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  );
                } else {
                  return const Center(child: GameLoading());
                }
              },
            ),
          ],
        ));
  }
}
