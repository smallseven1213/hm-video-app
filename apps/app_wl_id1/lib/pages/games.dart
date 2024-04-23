import 'package:app_wl_id1/widgets/no_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/games_controller.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/game_area_templates/game_area_template_2.dart';

class GamesPage extends StatefulWidget {
  final int gameAreaId;

  const GamesPage({
    Key? key,
    required this.gameAreaId,
  }) : super(key: key);

  @override
  GamesPageState createState() => GamesPageState();
}

class GamesPageState extends State<GamesPage> {
  // DISPOSED SCROLL CONTROLLER
  final scrollController = ScrollController();
  late final GamesController gamesController;

  @override
  void initState() {
    super.initState();
    gamesController = GamesController(
      gameAreaId: widget.gameAreaId,
      scrollController: scrollController,
    );
  }

  @override
  void dispose() {
    gamesController.dispose();
    if (scrollController.hasClients) {
      scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'HOT GAMES',
      ),
      body: Obx(() {
        var games = gamesController.gameList.value;
        int totalRows = (games.length / 2).ceil();
        return CustomScrollView(
          physics: kIsWeb ? null : const BouncingScrollPhysics(),
          controller: scrollController,
          scrollBehavior:
              ScrollConfiguration.of(context).copyWith(scrollbars: false),
          slivers: [
            if (games.isEmpty)
              const SliverToBoxAdapter(
                child: NoDataWidget(),
              ),
            if (totalRows > 0)
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      int firstGameIndex = index * 2;
                      int secondGameIndex = firstGameIndex + 1;

                      var firstGame = games[firstGameIndex];
                      var secondGame = secondGameIndex < games.length
                          ? games[secondGameIndex]
                          : null;

                      // logger.i('RENDER SLIVER VOD GRID');
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: GameAreaTemplate2Data(
                                    gameDetail: firstGame),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: secondGame != null
                                      ? GameAreaTemplate2Data(
                                          gameDetail: secondGame)
                                      : const SizedBox.shrink()),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                    childCount: totalRows,
                  ),
                ),
              ),
            // ignore: prefer_const_constructors
            // if (gamesController.isLoading.value)
            // const SliverToBoxAdapter(
            //   child: Container(),
            // ),
            // if (widget.displayNoMoreData)
            //   SliverToBoxAdapter(
            //     child: widget.noMoreWidget,
            //   ),
          ],
        );
      }),
    );
  }
}
