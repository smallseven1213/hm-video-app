import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class Vods extends StatelessWidget {
  final ScrollController? scrollController;
  const Vods({
    Key? key,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // controller: scrollController,
      itemCount: 100000,
      itemBuilder: (BuildContext context, int index) {
        logger.i('RENDER VOD ${index + 1}');
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://picsum.photos/id/${index + 1}/200/200'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VOD ${index + 1}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
