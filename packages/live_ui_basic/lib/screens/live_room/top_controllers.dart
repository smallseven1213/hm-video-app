import 'package:flutter/material.dart';
import 'package:live_core/widgets/rank_provider.dart';

class TopControllers extends StatelessWidget {
  const TopControllers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RankProvider(
      child: Container(
        height: 100,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: 135,
            ),
            Expanded(
              child: Container(),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 33,
                height: 33,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Center(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
