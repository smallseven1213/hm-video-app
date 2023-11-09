import 'dart:ui';

import 'package:app_tt/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared/modules/user/user_info_consumer.dart';

import '../home/controllers/home_page_controller.dart';
import 'user_card.dart';

class UserHeader extends SliverPersistentHeaderDelegate {
  final BuildContext context;

  UserHeader({
    required this.context,
  });

  @override
  double get minExtent {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return kToolbarHeight + statusBarHeight;
  }

  @override
  double get maxExtent =>
      164 + kToolbarHeight + MediaQuery.of(context).padding.top;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final shouldShowAppBar = shrinkOffset >= 164;

    return shouldShowAppBar
        ? UserInfoConsumer(
            child: (info, isVIP, isGuest) => AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                info.nickname ?? I18n.memberCenter,
                style: const TextStyle(color: Colors.black),
              ),
              centerTitle: true, // This will center the title
              actions: <Widget>[
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/svgs/ic-search.svg',
                    width: 17,
                    height: 17,
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ), // First button with "add" icon
                  onPressed: () {
                    // Define your action here
                  },
                ),
                GetBuilder<HomePageController>(
                  builder: (controller) => IconButton(
                    icon: SvgPicture.asset(
                      'assets/svgs/ic-filter.svg',
                      width: 14,
                      height: 14,
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
                    onPressed: () {
                      controller.toggleDrawer();
                    },
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            height: maxExtent - shrinkOffset,
            child: UserInfoConsumer(
              child: (info, isVIP, isGuest) => UserCard(info: info),
            ),
          );
  }

  @override
  bool shouldRebuild(covariant UserHeader oldDelegate) {
    return false;
  }
}


// class UserHeader extends SliverPersistentHeaderDelegate {
//   final BuildContext context;

//   UserHeader({
//     required this.context,
//   });

//   @override
//   double get minExtent {
//     final double statusBarHeight = MediaQuery.of(context).padding.top;
//     return kToolbarHeight + statusBarHeight;
//   }

//   @override
//   double get maxExtent =>
//       200; // You can adjust this value for the initial height of the UserHeader

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     final double opacity = 1 - shrinkOffset / maxExtent;
//     final double percentage = shrinkOffset / maxExtent;

//     final double imageSize = lerpDouble(80, kToolbarHeight - 20, percentage)!;
//     final double fontSize = lerpDouble(14, 15, percentage)!;

//     final screenWidth = MediaQuery.of(context).size.width;

//     final systemTopBarHeight = MediaQuery.of(context).padding.top;

//     return UserInfoConsumer(
//       child: (info, isVIP, isGuest) {
//         final textPainter = TextPainter(
//           text: TextSpan(
//             text: info.nickname,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
//           ),
//           maxLines: 1,
//           textDirection: TextDirection.ltr,
//         );
//         textPainter.layout();
//         final textWidth = textPainter.width;
//         final leftPadding = (screenWidth - imageSize - textWidth - 8) / 2;

//         return Container(
//           color: const Color(0xFF001a40).withOpacity(1 - opacity),
//           child: Stack(
//             children: [
//               if (opacity > 0)
//                 Container(
//                   height: 200,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Color.fromRGBO(67, 120, 220, 0.65),
//                         Color(0xFF001C46),
//                       ],
//                       stops: [
//                         -0.06,
//                         1.0,
//                       ],
//                     ),
//                   ),
//                 ),
//               Positioned(
//                 top: lerpDouble(
//                     100,
//                     ((kToolbarHeight - imageSize) / 2) + systemTopBarHeight,
//                     percentage),
//                 left: lerpDouble(10, leftPadding, percentage)!,
//                 child: ActorAvatar(
//                   photoSid: info.avatar,
//                   width: imageSize,
//                   height: imageSize,
//                 ),
//               ),
//               Positioned(
//                   top: lerpDouble(
//                       105,
//                       ((kToolbarHeight - fontSize) / 2) + systemTopBarHeight,
//                       percentage),
//                   left:
//                       lerpDouble(100, leftPadding + imageSize + 8, percentage)!,
//                   child: Text(
//                     info.nickname ?? '',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: fontSize,
//                         color: Colors.white),
//                   )),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   bool shouldRebuild(covariant UserHeader oldDelegate) {
//     return false;
//   }
// }
