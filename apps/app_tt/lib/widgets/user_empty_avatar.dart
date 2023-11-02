import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserEmptyAvatar extends StatelessWidget {
  const UserEmptyAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100 / 2),
      ),
      child: SizedBox(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100 / 2),
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                color: const Color(0xff262626),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/take-picture.png'),
                      width: 40,
                      height: 40,
                    ),
                    Text('添加頭像',
                        style: TextStyle(color: Colors.white, fontSize: 11))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
