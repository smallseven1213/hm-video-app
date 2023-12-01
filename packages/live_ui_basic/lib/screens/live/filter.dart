import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.filter_list, color: Color(0xff9a9ba1)),
          const SizedBox(width: 4),
          const Text(
            "篩選",
            style: TextStyle(color: Color(0xff9a9ba1), fontSize: 10),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.sort, color: Color(0xff9a9ba1)),
          const SizedBox(width: 4),
          const Text(
            "排序",
            style: TextStyle(color: Color(0xff9a9ba1), fontSize: 10),
          ),
        ],
      ),
    );
  }
}
