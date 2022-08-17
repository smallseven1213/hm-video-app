import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/styles.dart';

class VDLabelItem extends StatelessWidget {
  final int id;
  final String label;
  final VoidCallback? onTap;

  const VDLabelItem(
      {Key? key, required this.id, required this.label, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          top: 4,
          bottom: 5,
        ),
        decoration: BoxDecoration(
          color: color7,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
