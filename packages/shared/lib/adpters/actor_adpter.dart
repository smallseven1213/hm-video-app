import 'package:hive/hive.dart';

import '../models/actor.dart';

class ActorAdapter extends TypeAdapter<Actor> {
  @override
  final int typeId = 4;

  @override
  Actor read(BinaryReader reader) {
    final id = reader.readInt();
    final name = reader.readString();
    final photoSid = reader.readString();

    return Actor(id, name, photoSid);
  }

  @override
  void write(BinaryWriter writer, Actor obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.photoSid);
  }
}
