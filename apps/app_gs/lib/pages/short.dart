import 'dart:math';

import 'package:flutter/material.dart';

class ShortPage extends StatefulWidget {
  final int itemCount;

  const ShortPage({Key? key, required this.itemCount}) : super(key: key);

  @override
  _ShortPageState createState() => _ShortPageState();
}

class _ShortPageState extends State<ShortPage> {
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.itemCount,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Expanded(
                  child: Stack(
                children: [
                  Center(
                    child: Text(
                      '視頻編號：${index + 1}',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '視頻描述：這是第${index + 1}個短視頻',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.favorite_border),
                                color: Colors.white,
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.comment),
                                color: Colors.white,
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.share),
                                color: Colors.white,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
              Container(
                height: 90,
                // gradient background
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Color(0xFF002869),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(Icons.home),
                          color: Colors.white,
                          onPressed: () {},
                        )),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(Icons.star),
                          color: Colors.white,
                          onPressed: () {},
                        )),
                  ],
                ),
              )
            ],
          );
          // return Stack(
          //   children: [
          //     // 播放器
          //     Center(
          //       child: Text(
          //         '視頻編號：${index + 1}',
          //         style: TextStyle(
          //           fontSize: 24,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //     // 視頻描述和互動按鈕
          // Positioned(
          //   bottom: 0,
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     padding: EdgeInsets.all(16),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           '視頻描述：這是第${index + 1}個短視頻',
          //           style: TextStyle(
          //             fontSize: 16,
          //             color: Colors.white,
          //           ),
          //         ),
          //         SizedBox(height: 8),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             IconButton(
          //               icon: Icon(Icons.favorite_border),
          //               color: Colors.white,
          //               onPressed: () {},
          //             ),
          //             IconButton(
          //               icon: Icon(Icons.comment),
          //               color: Colors.white,
          //               onPressed: () {},
          //             ),
          //             IconButton(
          //               icon: Icon(Icons.share),
          //               color: Colors.white,
          //               onPressed: () {},
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          //   ],
          // );
        },
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
