// ChannelStyle2 is a stateless widget, return Text 'STYLE 2
import 'package:app_gs/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

class ChannelStyle4 extends StatelessWidget {
  final int channelId;
  const ChannelStyle4({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Header(
                text: '人氣女優',
                moreButton: InkWell(
                    onTap: () => {
                          MyRouteDelegate.of(context).push(
                            AppRoutes.actors.value,
                          )
                        },
                    child: const Text(
                      '更多 >',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ))),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),
          SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      height: 277,
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage('assets/images/your_image.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        // gradient background
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            // INFO DATA
                            Row(
                              children: [
                                // height 60,width 60,circle image
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/your_image.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // width 10
                                const SizedBox(width: 10),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: const [
                                        Text('女優名',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Text('人氣',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    )),
                                Container(
                                  width: 100,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        MyRouteDelegate.of(context).push(
                                          AppRoutes.actor.value,
                                          args: {
                                            'id': 1,
                                            'title': '女優名',
                                          },
                                        );
                                      },
                                      child: const Text(
                                        '查看全部',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.red),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            // LIST HORIZONTAL
                            Container(
                              height: 159,
                              child: ListView.builder(
                                itemCount: 10,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context,
                                    int horizontalIndex) {
                                  return Container(
                                    width: 119,
                                    height: 159,
                                    margin: const EdgeInsets.only(right: 8),
                                    color: Colors
                                        .blue[(horizontalIndex % 9 + 1) * 100],
                                    child: Center(
                                      child: Text(
                                        'Item $horizontalIndex',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: 10,
                ),
              )),
        ],
      ),
    );
  }
}
