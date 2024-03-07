import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../localization/live_localization_delegate.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => MyRouteDelegate.of(context).push("/live_search"),
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF323d5c),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.search,
                      color: Colors.white54,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      localizations.translate('search'),
                      style: const TextStyle(
                        color: Color(0xFF5a6077),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () => MyRouteDelegate.of(context).push("/streamer_rank"),
          child: const Image(
            image:
                AssetImage('packages/live_ui_basic/assets/images/ic_rank.webp'),
            width: 30,
            height: 30,
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
            onTap: () => launchUrl(
                Uri.parse(
                    "https://tawk.to/chat/65bf6f540ff6374032c9276f/1hlpslpb2"),
                webOnlyWindowName: '_blank'),
            child: SvgPicture.asset(
              'packages/live_ui_basic/assets/svgs/ic_service.svg',
              fit: BoxFit.cover,
              width: 30,
              height: 30,
            ))
      ],
    );
  }
}
