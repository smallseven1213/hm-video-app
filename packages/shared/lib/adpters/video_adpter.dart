// VideoAdpter from VideoDatabaseField

import 'package:hive/hive.dart';

import '../models/channel_info.dart';
import '../models/tag.dart';
import '../models/video_database_field.dart';

class VideoDatabaseFieldAdapter extends TypeAdapter<VideoDatabaseField> {
  @override
  final int typeId = 1; // 您需要为该类型分配一个唯一的 typeId

  @override
  VideoDatabaseField read(BinaryReader reader) {
    final id = reader.readInt();
    final coverVertical = reader.readString();
    final coverHorizontal = reader.readString();
    final timeLength = reader.readInt();
    final tags = reader.readList().cast<Tag>();
    final title = reader.readString();
    final videoViewTimes = reader.readInt();
    final imageRatio = reader.readDouble();
    final detail = reader.read() as Data;
    final isEmbeddedAds = reader.readBool();
    final isEditing = reader.readBool();

    return VideoDatabaseField(
      id: id,
      coverVertical: coverVertical,
      coverHorizontal: coverHorizontal,
      timeLength: timeLength,
      tags: tags,
      title: title,
      videoViewTimes: videoViewTimes,
      isEmbeddedAds: isEmbeddedAds,
      detail: detail,
      isEditing: isEditing,
      imageRatio: imageRatio,
    );
  }

  @override
  void write(BinaryWriter writer, VideoDatabaseField obj) {
    // writer.writeInt(obj.id);
    // writer.writeString(obj.coverVertical);
    // writer.writeString(obj.coverHorizontal);
    // writer.writeInt(obj.timeLength);
    // writer.writeList(obj.tags);
    // writer.writeString(obj.title);
    // writer.writeInt(obj.videoViewTimes);
    // writer.writeDouble(obj.imageRatio ?? 1);
    // writer.write(obj.detail);
    // writer.writeBool(obj.isEmbeddedAds);
    // writer.writeBool(obj.isEditing);
    writer.writeInt(obj.id ?? 0);
    writer.writeString(obj.title ?? '');
    writer.writeInt(obj.timeLength ?? 0);
    writer.writeString(obj.coverVertical ?? '');
    writer.writeString(obj.coverHorizontal ?? '');
    writer.writeList(obj.tags ?? []);
    writer.writeInt(obj.videoViewTimes ?? 0);
  }
}
