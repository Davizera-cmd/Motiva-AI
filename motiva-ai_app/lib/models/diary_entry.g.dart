import 'package:hive/hive.dart';
import 'package:motiva_ai/models/diary_entry.dart';

class DiaryEntryAdapter extends TypeAdapter<DiaryEntry> {
  @override
  final int typeId = 1;

  @override
  DiaryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiaryEntry(
      id:           fields[0] as String,
      dateInMillis: fields[1] as int,
      difficulty:   fields[2] as String,
      notes:        fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DiaryEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.dateInMillis)
      ..writeByte(2)..write(obj.difficulty)
      ..writeByte(3)..write(obj.notes);
  }
}
