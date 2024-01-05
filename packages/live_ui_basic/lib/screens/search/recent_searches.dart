import 'package:flutter/material.dart';

class RecentSearches extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _RecentSearchesState createState() => _RecentSearchesState();
}

class _RecentSearchesState extends State<RecentSearches> {
  int _selectedFilter = 0;
  final List<String> _filters = ['全部>全部', '女神', '熱門', '全部>全部'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          direction: Axis.horizontal, // 標籤的排列方向
          spacing: 8, // 標籤之間的水平間距
          runSpacing: 8, // 標籤之間的垂直間距
          children: [
            '全部>全部',
            '女神',
            '熱門',
            '熱門2',
            '熱門2',
            '熱門2',
            '熱門2',
            '熱門2',
            '熱門2',
            '熱門2',
            '熱門2'
          ]
              .map(
                (tag) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
                  decoration: BoxDecoration(
                    color: Color(0xFF343b4f),
                  ),
                  child: Text(
                    '六個字六個字',
                    style: TextStyle(
                      color: Color(0xFF6f6f79),
                    ),
                  ),
                ),
              )
              .toList()
              .cast<Widget>(),
        ),
      ],
    );
  }
}
