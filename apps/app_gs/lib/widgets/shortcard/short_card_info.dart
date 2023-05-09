import 'package:app_gs/widgets/actor_avatar.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/navigator/delegate.dart';

import 'short_card_info_tag.dart';

class ShortCardInfo extends StatelessWidget {
  final int index;
  final Vod data;

  const ShortCardInfo({
    Key? key,
    required this.index,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('data: ${data.toJson()}');
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 演員
            if (data.actors!.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ActorAvatar(
                      photoSid: data.actors![0].photoSid,
                      width: 30,
                      height: 30),
                  const SizedBox(width: 6),
                  Text(data.actors![0].name,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      )),
                ],
              ),
            // 供應商
            if (data.supplier != null) ...[
              InkWell(
                onTap: () => MyRouteDelegate.of(context).push(
                    AppRoutes.supplier.value,
                    useBottomToTopAnimation: true,
                    args: {
                      'id': data.supplier!.id,
                    }),
                child: Row(children: [
                  const SizedBox(height: 8),
                  Text(data.supplier!.aliasName ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      )),
                  const SizedBox(height: 8),
                ]),
              )
            ],

            // 標籤
            if (data.tags!.isNotEmpty)
              Row(
                  children: data.tags!
                      .map((e) => InkWell(
                          onTap: () => MyRouteDelegate.of(context).push(
                                  AppRoutes.supplierTag.value,
                                  useBottomToTopAnimation: true,
                                  args: {
                                    'id': data.supplier!.id,
                                  }),
                          child: ShortCardInfoTag(name: '#${e}')))
                      .toList()
                  // const [
                  //   data.tag.length > 0
                  //       ? ShortCardInfoTag(name: '#${data.tag[0]}')
                  //       : SizedBox.shrink(),
                  //   ShortCardInfoTag(name: '#免費'),
                  //   SizedBox(width: 8),
                  //   ShortCardInfoTag(name: '#網紅'),
                  //   SizedBox(width: 8),
                  //   ShortCardInfoTag(name: '#大集合'),
                  // ],
                  ),
          ],
        ),
      ),
    );
  }
}
