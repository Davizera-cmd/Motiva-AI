import 'package:flutter/foundation.dart';
import 'package:motiva_ai/models/user_preferences.dart';
import 'package:motiva_ai/services/storage_service.dart';

/// AbstinenceController — lógica de cálculo e reset do contador.
/// Equivalente ao AbstinenceController.js + LaunchedEffect do Android.
/// Atende: RF01 (contador), RF03 (recaída).
///
/// Extende ChangeNotifier para notificar a UI (Provider pattern).
class AbstinenceController extends ChangeNotifier {
  UserPreferences? _preferences;
  Duration _elapsed = Duration.zero;

  UserPreferences? get preferences => _preferences;
  Duration         get elapsed     => _elapsed;

  int get days    => _elapsed.inDays;
  int get hours   => _elapsed.inHours.remainder(24);
  int get minutes => _elapsed.inMinutes.remainder(60);
  int get seconds => _elapsed.inSeconds.remainder(60);

  /// String formatada: "DD dias HH:MM:SS"
  String get formattedTime {
    final d = days.toString().padLeft(2, '0');
    final h = hours.toString().padLeft(2, '0');
    final m = minutes.toString().padLeft(2, '0');
    final s = seconds.toString().padLeft(2, '0');
    return '$d dias  $h:$m:$s';
  }

  Future<void> load() async {
    _preferences = StorageService.getPreferences();
    _tick();
    notifyListeners();
  }

  void tick() {
    _tick();
    notifyListeners();
  }

  void _tick() {
    if (_preferences == null) return;
    final start = DateTime.fromMillisecondsSinceEpoch(
      _preferences!.abstinenceStartDate,
    );
    _elapsed = DateTime.now().difference(start);
  }

  /// RF03 — Reinicia o contador (marca uma recaída).
  Future<void> resetCounter() async {
    if (_preferences == null) return;
    final updated = _preferences!.copyWith(
      abstinenceStartDate: DateTime.now().millisecondsSinceEpoch,
    );
    await StorageService.savePreferences(updated);
    _preferences = updated;
    _elapsed     = Duration.zero;
    notifyListeners();
  }
}
