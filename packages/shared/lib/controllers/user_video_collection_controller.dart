import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/video_database_field.dart';

class UserCollectionController extends GetxController {
  static const String _boxName = 'userVideoCollection';
  late Box<VideoDatabaseField> _userCollectionBox;
  var videos = <VideoDatabaseField>[].obs;

  UserCollectionController() {
    _init();
  }

  Future<void> _init() async {
    _userCollectionBox = await Hive.openBox<VideoDatabaseField>(_boxName);

    if (_userCollectionBox.isEmpty) {
      await _fetchAndSaveCollection();
    } else {
      videos.value = _userCollectionBox.values.toList();
    }
  }

  Future<void> _fetchAndSaveCollection() async {
    // List<Video> fetchedVideos = await fetchCollectionVideo();
    // videos.value = fetchedVideos;

    // for (Video video in fetchedVideos) {
    //   await _userCollectionBox.put(video.id, video);
    // }
  }

  // addVideo to collection
  void addVideo(VideoDatabaseField video) async {
    if (videos.firstWhereOrNull((v) => v.id == video.id) != null) {
      videos.removeWhere((v) => v.id == video.id);
    }
    videos.add(video);
    await _userCollectionBox.put(video.id, video);
  }

  // removeVideo from collection
  void removeVideo(List<int> ids) async {
    videos.removeWhere((v) => ids.contains(v.id));
    for (var id in ids) {
      await _userCollectionBox.delete(id);
    }
  }
}
