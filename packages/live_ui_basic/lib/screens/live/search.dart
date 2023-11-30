import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFF323d5c),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              // padding l 10, child is Icon
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
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
      ],
    );
  }
}
