import 'package:flutter/material.dart';
import 'package:shared/navigator/delegate.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(10),
          //   child: Image.asset(
          //     'assets/images/avatar.png',
          //     width: 60,
          //     height: 60,
          //   ),
          // ),
          // 80 x 80的圓型白色container
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.grey,
            ),
          ),

          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guest',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Please login',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              MyRouteDelegate.of(context).push('/login');
            },
            child: Text(
              '登入/註冊',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.settings,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
