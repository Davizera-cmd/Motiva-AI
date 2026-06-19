import 'package:flutter/foundation.dart';
import 'package:motiva_ai/models/diary_entry.dart';
import 'package:motiva_ai/services/storage_service.dart';

/// DiaryController — gerencia o diário emocional do usuário.
/// Atende: RF05 (Diário de Bordo).
class DiaryController extends ChangeNotifier {
  List<DiaryEntry> _entries = [];

  List<DiaryEntry> get entries => List.unmodifiable(_entries);

  Future<void> load() async {
    _entries = StorageService.getDiaryEntries();
    notifyListeners();
  }

  Future<void> addEntry({
    required String difficulty,
    required String notes,
  }) async {
    final entry = DiaryEntry.create(difficulty: difficulty, notes: notes);
    await StorageService.saveDiaryEntry(entry);
    _entries = StorageService.getDiaryEntries();
    notifyListeners();
  }

  Future<void> updateEntry(DiaryEntry entry) async {
    await StorageService.saveDiaryEntry(entry);
    _entries = StorageService.getDiaryEntries();
    notifyListeners();
  }

  Future<void> deleteEntry(String id) async {
    await StorageService.deleteDiaryEntry(id);
    _entries = StorageService.getDiaryEntries();
    notifyListeners();
  }
}
