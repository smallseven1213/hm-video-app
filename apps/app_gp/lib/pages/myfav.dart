import 'package:flutter/material.dart';

class MyFavoritesPage extends StatelessWidget {
  const MyFavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: const Center(
        child: Text('My Favorites'),
      ),
    );
  }
}
