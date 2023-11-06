import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

import 'package:game/apis/game_api.dart';
import 'package:game/models/game_banner_marquee_consumer.dart';
import 'package:game/models/game_activity.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/utils/show_form_dialog.dart';
import 'package:game/widgets/button.dart';

import '../../localization/game_localization_delegate.dart';

final logger = Logger();
final GameLobbyApi gameLobbyApi = GameLobbyApi();

class GameActivity extends StatefulWidget {
  final int? id;
  const GameActivity({Key? key, this.id}) : super(key: key);

  @override
  State<GameActivity> createState() => _GameActivityState();
}

class _GameActivityState extends State<GameActivity> {
  List activityList = [];
  List<bool> _isExpandedList = [];
  bool buttonDisable = false;

  @override
  void initState() {
    super.initState();
    getActivityList();
  }

  void getActivityList() async {
    try {
      var res = await gameLobbyApi.getActivityList();
      setState(() {
        activityList = res;
        _isExpandedList = List.filled(res.length, false);
      });
    } catch (error) {
      logger.i('getActivityList $error');
    }
  }

  void submitCampaign(context, int id) async {
    try {
      var res = await gameLobbyApi.submitCampaign(id);
      if (res['code'] == '00') {
        showFormDialog(
          context,
          title: activityResStatus[res['status']]!,
          content: SizedBox(
            height: 85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xff62c152),
                  size: 40,
                ),
                const SizedBox(height: 20),
                if (res['message'].isNotEmpty)
                  Text(
                    res['message'],
                    style: TextStyle(
                        color: gameLobbyPrimaryTextColor, fontSize: 14),
                  ),
              ],
            ),
          ),
          confirmText: res['status'] == activityButtonStatus['ENABLE']
              ? GameLocalizations.of(context)!.translate('close')
              : GameLocalizations.of(context)!.translate('confirm'),
          onConfirm: () => {
            if (res['status'] != activityButtonStatus['ENABLE'])
              setState(() => buttonDisable = true),
            Navigator.pop(context),
          },
        );
      } else {
        showFormDialog(
          context,
          title: '申請失敗',
          content: SizedBox(
            height: 85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 40,
                ),
                const SizedBox(height: 20),
                if (res['message'].isNotEmpty)
                  Text(
                    res['message'],
                    style: TextStyle(
                        color: gameLobbyPrimaryTextColor, fontSize: 14),
                  ),
              ],
            ),
          ),
          confirmText: GameLocalizations.of(context)!.translate('confirm'),
          onConfirm: () => {
            Navigator.pop(context),
          },
        );
      }
    } catch (error) {
      logger.i('submitCampaign $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: gameLobbyBgColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: gameLobbyBgColor,
        ),
        centerTitle: true,
        title: Text(
          localizations.translate('hot_events'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: gameLobbyAppBarTextColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: gameLobbyAppBarIconColor),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: gameLobbyBgColor,
          height: double.infinity,
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: activityList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: gameItemMainColor,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .15),
                        offset: Offset(0, 0),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isExpandedList[index] = !_isExpandedList[index];
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (activityList[index].imgUrl != null)
                                AspectRatio(
                                  aspectRatio: 360 / 145,
                                  child: Image.network(
                                    activityList[index].imgUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              top: 0,
                                              bottom: 2,
                                              left: 1,
                                              right: kIsWeb ? 8 : 1),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: activityTypeMapper[
                                                  activityList[index]
                                                      .type]!['color'],
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            activityTypeMapper[
                                                    activityList[index]
                                                        .type]!['name']
                                                .toString(),
                                            style: TextStyle(
                                              color: activityTypeMapper[
                                                  activityList[index]
                                                      .type]!['color'],
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          activityList[index].title,
                                          style: TextStyle(
                                            color: gameLobbyPrimaryTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    _isExpandedList[index]
                                        ? Transform.rotate(
                                            angle: 3.14,
                                            child: Icon(
                                              Icons
                                                  .arrow_drop_down_circle_outlined,
                                              color: gameActivityIconColor,
                                              size: 16,
                                            ),
                                          )
                                        : const Icon(
                                            Icons
                                                .arrow_drop_down_circle_outlined,
                                            color: Color(0xffebfe69),
                                            size: 16,
                                          )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 8),
                                child: Text(
                                  activityList[index].subTitle,
                                  style: TextStyle(
                                    color: gameLobbyTabTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_isExpandedList[index] == false)
                          const SizedBox(height: 10),
                        if (_isExpandedList[index])
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Column(
                              children: [
                                Container(
                                  height: 1,
                                  color: gameLobbyDividerColor,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: HtmlWidget(
                                    activityList[index].content,
                                    textStyle: TextStyle(
                                      color: gameActivityContentTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                if (activityList[index].buttonStyle !=
                                        activityButtonType['NONE'] ||
                                    activityList[index].buttonName != null)
                                  GameBannerAndMarqueeConsumer(
                                    child:
                                        (banner, marquee, customerServiceUrl) =>
                                            SizedBox(
                                      width: 220,
                                      child: GameButton(
                                        disabled: buttonDisable,
                                        text: activityList[index].buttonName,
                                        onPressed: () => {
                                          if (activityList[index].buttonStyle ==
                                              activityButtonType['CS'])
                                            {
                                              launch(customerServiceUrl,
                                                  webOnlyWindowName: '_blank')
                                            }
                                          else
                                            submitCampaign(context,
                                                activityList[index].id),
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
