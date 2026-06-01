import 'package:motiva_ai/models/user_preferences.dart';
import 'package:motiva_ai/services/storage_service.dart';
import 'package:motiva_ai/services/notification_service.dart';

/// OnboardingController — orquestra o fluxo de onboarding e configurações.
/// Atende: RF06.
class OnboardingController {
  static Future<void> completeOnboarding({
    required String addictionType,
    required String aiPrompt,
    required int    abstinenceStartDate,
    required int    notificationHour,
    required int    notificationMinute,
  }) async {
    final prefs = UserPreferences(
      addictionType:       addictionType,
      aiPrompt:            aiPrompt,
      abstinenceStartDate: abstinenceStartDate,
      notificationHour:    notificationHour,
      notificationMinute:  notificationMinute,
      onboardingCompleted: true,
    );
    await StorageService.savePreferences(prefs);
    await NotificationService.requestPermissions();
    await NotificationService.scheduleDailyNotification(notificationHour, notificationMinute);
  }

  static Future<void> updateSettings({
    required UserPreferences current,
    String?                  addictionType,
    required String          aiPrompt,
    required int             notificationHour,
    required int             notificationMinute,
  }) async {
    final updated = current.copyWith(
      addictionType:      addictionType,
      aiPrompt:           aiPrompt,
      notificationHour:   notificationHour,
      notificationMinute: notificationMinute,
    );
    await StorageService.savePreferences(updated);
    await NotificationService.scheduleDailyNotification(notificationHour, notificationMinute);
  }

  static bool isOnboardingCompleted() {
    return StorageService.getPreferences()?.onboardingCompleted ?? false;
  }
}
