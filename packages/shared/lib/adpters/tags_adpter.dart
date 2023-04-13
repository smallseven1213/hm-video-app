import 'package:hive/hive.dart';
import '../models/tag.dart';

class TagsAdapter extends TypeAdapter<Tag> {
  @override
  final int typeId = 2;

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
    writer.writeInt(obj.id!);
    writer.writeString(obj.name!);
  }
}
