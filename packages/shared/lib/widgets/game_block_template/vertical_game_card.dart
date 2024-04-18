import 'package:flutter/material.dart';
import 'tag.dart';

const kPrimaryColor = Color(0xff00669F);
const kCardBgColor = Color(0xff02275C);

class VerticalGameCard extends StatefulWidget {
  const VerticalGameCard({super.key});

  @override
  _VerticalGameCardState createState() => _VerticalGameCardState();
}

class _VerticalGameCardState extends State<VerticalGameCard> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 360 / 560,
      child: Column(
        children: [
          _buildHeader(context),
          _buildGameGrid(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Sexy Live Dealers',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              side: const BorderSide(color: kPrimaryColor),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'See All',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameGrid(BuildContext context) {
    return Expanded(
      // 使用Expanded确保Column占满剩余空间
      child: Column(
        children: [
          Expanded(
            // 每个Row也使用Expanded确保平均分配空间
            child: Row(
              children: [
                Expanded(child: GameCard()), // 每个GameCard使用Expanded确保填满可用空间
                SizedBox(width: 8),
                Expanded(child: GameCard()),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                Expanded(child: GameCard()),
                SizedBox(width: 8),
                Expanded(child: GameCard()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildGameImage(),
        _buildGameTags(),
      ],
    );
  }

  Widget _buildGameImage() {
    return AspectRatio(
      aspectRatio: 168 / 200,
      child: Stack(
        children: [
          Image.network(
            'https://5b0988e595225.cdn.sohucs.com/images/20170820/726480d5869049e29698e0d472715406.jpeg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Game Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameTags() {
    return Container(
      width: double.infinity,
      color: kCardBgColor,
      padding: const EdgeInsets.all(8),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 5.0,
        runSpacing: 5.0,
        clipBehavior: Clip.antiAlias,
        children: [
          TagWidget(name: 'Baccarat'),
        ],
      ),
    );
  }
}
