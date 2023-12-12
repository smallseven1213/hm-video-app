import 'package:flutter/material.dart';
import 'package:shared/navigator/delegate.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF323d5c),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                // padding l 10, child is Icon
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.search,
                    color: Colors.white54,
                  ),
                ),
                // padding l 10, child is Text
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: Color(0xFF5a6077),
                    ),
                  ),
                ),
              ],
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
      ],
    );
  }
}
