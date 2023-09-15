import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Center(
        child: Column(
          children: [
            const Image(
              image: AssetImage('assets/images/list_no_more.png'),
              width: 48,
              height: 48,
            ),
            Text('這裡什麼都沒有',
                style: TextStyle(color: Colors.white.withOpacity(0.6)))
          ],
        ),
      ),
    );
  }
}
