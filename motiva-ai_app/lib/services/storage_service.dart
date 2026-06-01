import 'package:hive_flutter/hive_flutter.dart';
import 'package:motiva_ai/models/user_preferences.dart';
import 'package:motiva_ai/models/diary_entry.dart';
import 'package:motiva_ai/models/user_preferences.g.dart';
import 'package:motiva_ai/models/diary_entry.g.dart';

class StorageService {
  static const String _prefsBoxName = 'user_preferences';
  static const String _diaryBoxName = 'diary_entries';
  static const String _prefsKey     = 'prefs';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserPreferencesAdapter());
    Hive.registerAdapter(DiaryEntryAdapter());
    await Hive.openBox<UserPreferences>(_prefsBoxName);
    await Hive.openBox<DiaryEntry>(_diaryBoxName);
  }

  static UserPreferences? getPreferences() =>
      Hive.box<UserPreferences>(_prefsBoxName).get(_prefsKey);

  static Future<void> savePreferences(UserPreferences prefs) async =>
      Hive.box<UserPreferences>(_prefsBoxName).put(_prefsKey, prefs);

  static List<DiaryEntry> getDiaryEntries() {
    final entries = Hive.box<DiaryEntry>(_diaryBoxName).values.toList();
    entries.sort((a, b) => b.dateInMillis.compareTo(a.dateInMillis));
    return entries;
  }

  static Future<void> saveDiaryEntry(DiaryEntry entry) async =>
      Hive.box<DiaryEntry>(_diaryBoxName).put(entry.id, entry);
}
