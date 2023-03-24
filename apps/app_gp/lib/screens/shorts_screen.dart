import 'package:flutter/material.dart';

var imagesUrls = [
  'https://img.applealmond.com/2018/02/1519572192-fc0a03b34d40232fd0c982f419f748a0.jpg',
  'https://iphoneswallpapers.com/wp-content/uploads/2022/07/Fuji-iPhone-Wallpaper-HD.jpg'
      'https://images.unsplash.com/photo-1612821969256-55c71d64c245?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8aXBob25lJTIwd2FsbHBhcGVyJTIwaGR8ZW58MHx8MHx8&w=1000&q=80'
];

class ShortScreen extends StatelessWidget {
  final controller = PageController();
  ShortScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var items = List.generate(10000, (index) {
      return buildPage(
        context,
        color: Colors.blue,
        pageTitle: 'page 1',
        userInfo: 'User 1 Info',
        otherInfo: 'Other info for Page 1',
      );
    });

    return Scaffold(
      body: PageView(
        controller: controller,
        scrollDirection: Axis.vertical,
        children: [
          ...items,
        ],
      ),
    );
  }
}

Widget buildPage(
  BuildContext context, {
  required Color color,
  required String pageTitle,
  required String userInfo,
  required String otherInfo,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Container(
    width: screenWidth,
    height: screenHeight,
    color: color,
    child: Stack(
      children: [
        // Center(
        //   child: Text(pageTitle),
        // ),
        Positioned(
          left: 10,
          bottom: 90,
          child: Text(otherInfo),
        ),
        Positioned(
          right: 10,
          bottom: screenHeight / 2 - 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
