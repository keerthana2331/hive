import 'package:hive/hive.dart';
import 'task.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0; // Ensure the typeId matches the one in the @HiveType annotation

  @override
  Task read(BinaryReader reader) {
    // Read data in the same order it was written
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      title: fields[0] as String,
      description: fields[1] as String,
      isCompleted: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    // Write data in the same order as defined in read
    writer
      ..writeByte(3) // Number of fields in the class
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
