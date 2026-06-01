import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

@HiveType(typeId: 1)
class DiaryEntry extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int dateInMillis;
  @HiveField(2)
  final String difficulty;
  @HiveField(3)
  final String notes;

  DiaryEntry({
    required this.id,
    required this.dateInMillis,
    required this.difficulty,
    required this.notes,
  });

  factory DiaryEntry.create({
    required String difficulty,
    required String notes,
  }) {
    return DiaryEntry(
      id:           const Uuid().v4(),
      dateInMillis: DateTime.now().millisecondsSinceEpoch,
      difficulty:   difficulty,
      notes:        notes,
    );
  }
}
