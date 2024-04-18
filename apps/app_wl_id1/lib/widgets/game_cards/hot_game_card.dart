import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'tag.dart';

const kPrimaryColor = Color(0xff00669F);
const kCardBgColor = Color(0xff02275C);
const kTagColor = Color(0xff21488E);
const kTagTextColor = Color(0xff21AFFF);

final logger = Logger();

class HotGameCard extends StatelessWidget {
  const HotGameCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 300,
          maxHeight: 450, // 根据需求调整最大高度
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildGameGrid(context),
            ),
          ],
        ),
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
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              const GameCard(),
              const GameCard(),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const GameCard(),
              const GameCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class GameCard extends StatelessWidget {
  const GameCard({super.key});

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
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 168 / 120,
          child: Container(
            margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Image.network(
              'https://5b0988e595225.cdn.sohucs.com/images/20170820/726480d5869049e29698e0d472715406.jpeg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 5,
          child: Image(
            image: AssetImage('assets/images/hot.png'),
            fit: BoxFit.contain,
            height: 24,
          ),
        )
      ],
    );
  }

  Widget _buildGameTags() {
    return Container(
      width: double.infinity,
      color: kCardBgColor,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Game Name',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 5.0,
            runSpacing: 5.0,
            clipBehavior: Clip.antiAlias,
            children: [
              TagWidget(name: 'Baccarat'),
            ],
          ),
        ],
      ),
    );
  }
}
