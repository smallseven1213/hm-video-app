import 'package:hive/hive.dart';

import '../models/channel_info.dart';
import '../models/tag.dart';

class VideoDetailAdapter extends TypeAdapter<Data> {
  @override
  final int typeId = 3;

  @override
  Data read(BinaryReader reader) {
    return Data(
      id: reader.readInt(),
      dataType: reader.readInt(),
      title: reader.readString(),
      titleSub: reader.readString(),
      externalId: reader.readString(),
      chargeType: reader.readInt(),
      points: reader.readInt(),
      subScript: reader.readInt(),
      timeLength: reader.readInt(),
      coverVertical: reader.readString(),
      coverHorizontal: reader.readString(),
      tags: reader.readList().cast<Tag>(),
      videoViewTimes: reader.readInt(),
      videoCollectTimes: reader.readInt(),
      appIcon: reader.readString(),
      adUrl: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Data obj) {
    writer.writeInt(obj.id!);
    writer.writeInt(obj.dataType!);
    writer.writeString(obj.title!);
    writer.writeString(obj.titleSub!);
    writer.writeString(obj.externalId!);
    writer.writeInt(obj.chargeType!);
    writer.writeInt(obj.points!);
    writer.writeInt(obj.subScript!);
    writer.writeInt(obj.timeLength!);
    writer.writeString(obj.coverVertical!);
    writer.writeString(obj.coverHorizontal!);
    writer.writeList(obj.tags!);
    writer.writeInt(obj.videoViewTimes!);
    writer.writeInt(obj.videoCollectTimes!);
    writer.writeString(obj.appIcon!);
    writer.writeString(obj.adUrl!);
  }
}
