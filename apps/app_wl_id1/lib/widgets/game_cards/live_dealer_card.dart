import 'package:flutter/material.dart';
import 'tag.dart';

const kPrimaryColor = Color(0xff00669F);
const kCardBgColor = Color(0xff02275C);

class LiveDealerCard extends StatelessWidget {
  const LiveDealerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 560,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildGameGrid(context),
          ),
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
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 0,
        childAspectRatio: 0.7,
      ),
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) {
        return const GameCard();
      },
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
