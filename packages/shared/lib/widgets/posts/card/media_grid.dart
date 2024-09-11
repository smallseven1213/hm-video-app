import 'package:flutter/material.dart';
import 'package:shared/enums/file_type.dart';
import 'package:shared/widgets/sid_image.dart';

class AppColors {
  static const lockImage = Color(0xff3f4253);
}

class MediaGridWidget extends StatelessWidget {
  final List<dynamic> files;
  final int totalMediaCount;
  final int previewMediaCount;
  final bool isUnlock;
  final bool darkMode;

  const MediaGridWidget({
    Key? key,
    required this.files,
    required this.totalMediaCount,
    required this.previewMediaCount,
    required this.isUnlock,
    required this.darkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(
        totalMediaCount <= 6 ? totalMediaCount : 6,
        (index) => _buildMediaItem(context, index),
      ),
    );
  }

  Widget _buildMediaItem(BuildContext context, int index) {
    bool shouldShowLock = !isUnlock && index >= previewMediaCount;
    Color lockImageColor = darkMode ? AppColors.lockImage : Colors.white;

    return SizedBox(
      width: (MediaQuery.of(context).size.width - 32) / 3,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: files.length > index
              ? _buildFileItem(files[index], shouldShowLock)
              : _buildPlaceholderItem(shouldShowLock, lockImageColor),
        ),
      ),
    );
  }

  Widget _buildFileItem(dynamic file, bool shouldShowLock) {
    return Stack(
      children: [
        SidImage(sid: file.cover),
        if (file.type == FileType.video.index)
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
            ),
          ),
        if (shouldShowLock)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: Icon(Icons.lock, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholderItem(bool shouldShowLock, Color lockImageColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: shouldShowLock
          ? Container(
              decoration: BoxDecoration(
                color: lockImageColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(44, 49, 70, 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            )
          : const Icon(
              Icons.image,
              color: Colors.white,
            ),
    );
  }
}
