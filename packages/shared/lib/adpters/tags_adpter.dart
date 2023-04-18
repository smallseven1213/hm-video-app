import 'package:hive/hive.dart';
import '../enums/adapters.dart';
import '../models/tag.dart';

class TagsAdapter extends TypeAdapter<Tag> {
  @override
  final int typeId = adapterId(Adapters.tags);

  @override
  Tag read(BinaryReader reader) {
    final id = reader.readInt();
    final name = reader.readString();

    return Tag(
      id,
      name,
    );
  }

  @override
  void write(BinaryWriter writer, Tag obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
  }
}
