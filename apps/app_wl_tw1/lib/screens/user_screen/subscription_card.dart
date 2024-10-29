import 'package:flutter/material.dart';
import 'package:shared/modules/user/user_info_v2_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/enums/app_routes.dart';

import '../../localization/i18n.dart';

class VIPSubscriptionCard extends StatelessWidget {
  const VIPSubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return UserInfoV2Consumer(
      child: (info, isVIP, isGuest, isLoading, isInfoV2Init) {
        if (!isInfoV2Init || isVIP) {
          return Container();
        }
        return InkWell(
          onTap: () => MyRouteDelegate.of(context).push(AppRoutes.vip),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width - 20,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/purchase/img-vip.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 41,
                    right: 36,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Image(
                              image: AssetImage(
                                  'assets/images/purchase/icon-vip.webp'),
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                I18n.activateVipForFree,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            MyRouteDelegate.of(context).push(AppRoutes.vip),
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            left: 15,
                            right: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32.0),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Text(
                            I18n.viewDetails,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
