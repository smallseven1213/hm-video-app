import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/redemption_api.dart';
import 'package:shared/controllers/event_controller.dart';
import 'package:shared/controllers/redemption_controller.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/user/user_redemption_consumer.dart';
import '../config/colors.dart';
import '../screens/coin/no_data.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/button.dart';
import '../widgets/my_app_bar.dart';

final logger = Logger();
final redemptionApi = RedemptionApi();

class RedemptionPage extends StatefulWidget {
  const RedemptionPage({super.key});

  @override
  _RedemptionPageState createState() => _RedemptionPageState();
}

class _RedemptionPageState extends State<RedemptionPage> {
  bool isSwitched = false;
  TextEditingController? _controller;
  late RedemptionController redemptionController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    redemptionController = Get.find<RedemptionController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(
          title: '序號兌換',
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    color: AppColors.colors[ColorKeys.background],
                    child: Center(
                      child: AuthTextField(
                        controller: _controller!,
                        placeholderText: '請輸入序號',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Button(
                    onPressed: () async {
                      var result =
                          await redemptionApi.redeem(_controller!.text);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.fromLTRB(50, 0, 50, 200),
                            content: Text(
                              result,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        );
                        redemptionController.fetchData();
                      }
                    },
                    text: '兌換',
                    size: 'small',
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                '兌換記錄',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Expanded(
              child: Obx(() {
                final records = redemptionController.records;
                if (records.isEmpty) return const NoData();
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
                            color: AppColors.colors[ColorKeys.primary],
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
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(width: 22),
                          Text(
                            record.updatedAt ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
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
