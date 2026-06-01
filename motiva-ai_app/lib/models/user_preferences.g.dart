import 'package:hive/hive.dart';
import 'package:motiva_ai/models/user_preferences.dart';

class UserPreferencesAdapter extends TypeAdapter<UserPreferences> {
  @override
  final int typeId = 0;

  @override
  UserPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferences(
      addictionType:       fields[0] as String,
      aiPrompt:            fields[1] as String,
      abstinenceStartDate: fields[2] as int,
      notificationHour:    fields[3] as int,
      notificationMinute:  fields[4] as int,
      onboardingCompleted: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferences obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)..write(obj.addictionType)
      ..writeByte(1)..write(obj.aiPrompt)
      ..writeByte(2)..write(obj.abstinenceStartDate)
      ..writeByte(3)..write(obj.notificationHour)
      ..writeByte(4)..write(obj.notificationMinute)
      ..writeByte(5)..write(obj.onboardingCompleted);
  }
}
