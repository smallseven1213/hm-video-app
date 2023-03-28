import 'package:hive/hive.dart';

import '../models/channel_info.dart';

class TagsAdapter extends TypeAdapter<Tags> {
  @override
  final int typeId = 2;

  @override
  Tags read(BinaryReader reader) {
    final id = reader.readInt();
    final name = reader.readString();

    return Tags(
      id: id,
      name: name,
    );
  }

  @override
  void write(BinaryWriter writer, Tags obj) {
    writer.writeInt(obj.id!);
    writer.writeString(obj.name!);
  }
}
