import 'package:flutter/material.dart';

class CommentList extends StatelessWidget {
  const CommentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        itemCount: 11,
        itemBuilder: (context, index) {
          return CommentItem();
        },
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      // leading: CircleAvatar(
      //   backgroundImage: AssetImage('assets/user_avatar.png'),
      // ),
      title: Text('用戶ID', style: TextStyle(color: Colors.grey)),
      subtitle:
          Text('文字文字文字文字文字文字文字文字文字文字文字', style: TextStyle(color: Colors.grey)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('1,234', style: TextStyle(color: Colors.grey)),
          Icon(Icons.favorite_border, color: Colors.grey),
        ],
      ),
    );
  }
}
