import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/tag_games_controller.dart';
import 'package:shared/widgets/game_block_template/horizontal_game_card.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/no_data.dart';

class TagGamesPage extends StatefulWidget {
  final String tag;

  const TagGamesPage({
    Key? key,
    required this.tag,
  }) : super(key: key);

  @override
  TagGamesPageState createState() => TagGamesPageState();
}

class TagGamesPageState extends State<TagGamesPage> {
  // DISPOSED SCROLL CONTROLLER
  final scrollController = ScrollController();
  late final TagGamesController gamesController;

  @override
  void initState() {
    super.initState();
    gamesController = TagGamesController(
      tag: widget.tag,
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
      appBar: CustomAppBar(
        title: '#${widget.tag}',
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
                                child: GameCard(gameDetail: firstGame),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: secondGame != null
                                      ? GameCard(gameDetail: secondGame)
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
