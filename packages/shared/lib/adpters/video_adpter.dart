// VideoAdpter from VideoDatabaseField

import 'package:hive/hive.dart';

import '../enums/adapters.dart';
import '../models/tag.dart';
import '../models/vod.dart';

class VideoDatabaseFieldAdapter extends TypeAdapter<Vod> {
  @override
  final int typeId = adapterId(Adapters.video);

  @override
  Vod read(BinaryReader reader) {
    final id = reader.readInt();
    final coverVertical = reader.readString();
    final coverHorizontal = reader.readString();
    final timeLength = reader.readInt();
    final tags = reader.readList().cast<Tag>();
    final title = reader.readString();
    final videoViewTimes = reader.readInt();
    // final detail = reader.read() as Data;

    return Vod(
      id,
      title,
      coverVertical: coverVertical,
      coverHorizontal: coverHorizontal,
      timeLength: timeLength,
      tags: tags,
      videoViewTimes: videoViewTimes,
      // detail: detail,
    );
  }

  @override
  void write(BinaryWriter writer, Vod obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.title);
    writer.writeInt(obj.timeLength!);
    writer.writeString(obj.coverVertical!);
    writer.writeString(obj.coverHorizontal!);
    writer.writeList(obj.tags!);
    writer.writeInt(obj.videoViewTimes ?? 0);
  }
}
