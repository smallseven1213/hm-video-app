import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/redemption_api.dart';
import 'package:shared/controllers/redemption_controller.dart';
import 'package:shared/models/color_keys.dart';
import 'package:app_wl_tw2/localization/i18n.dart';

import '../config/colors.dart';
import '../screens/redemption/auth_text_field.dart';
import '../widgets/button.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/no_data.dart';

final logger = Logger();
final redemptionApi = RedemptionApi();

class RedemptionPage extends StatefulWidget {
  const RedemptionPage({super.key});

  @override
  RedemptionPageState createState() => RedemptionPageState();
}

class RedemptionPageState extends State<RedemptionPage> {
  TextEditingController? _controller;
  late RedemptionController redemptionController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    redemptionController = Get.find<RedemptionController>();
  }

  Future<void> _redeemRequest() async {
    var result = await redemptionApi.redeem(_controller!.text);
    logger.i('_redeemRequest result: $result');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(50, 0, 50, 200),
          content: Text(
            result,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.colors[ColorKeys.textPrimary],
            ),
          ),
        ),
      );
      redemptionController.fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: I18n.serialNumberExchange,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      color: AppColors.colors[ColorKeys.background],
                      child: Center(
                        child: AuthTextField(
                          label: "",
                          controller: _controller!,
                          placeholderText: I18n.enterSerialNumber,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Button(
                      onPressed: () => _redeemRequest(),
                      text: I18n.exchange,
                      size: 'small',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                I18n.redeemRecord,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.colors[ColorKeys.textPrimary],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: AppColors.colors[ColorKeys.menuBgColor],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    I18n.redeemName,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.colors[ColorKeys.tabBarTextColor],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    I18n.redeemTime,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.colors[ColorKeys.tabBarTextColor],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final records = redemptionController.records;
                if (records.isEmpty) return const NoDataWidget();
                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              record.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.colors[ColorKeys.textPrimary],
                              ),
                            ),
                          ),
                          const SizedBox(width: 22),
                          Text(
                            record.updatedAt ?? '',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.colors[ColorKeys.textPrimary],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ));
  }
}
