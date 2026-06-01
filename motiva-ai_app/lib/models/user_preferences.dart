import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class UserPreferences extends HiveObject {
  @HiveField(0)
  final String addictionType;
  @HiveField(1)
  final String aiPrompt;
  @HiveField(2)
  final int abstinenceStartDate;
  @HiveField(3)
  final int notificationHour;
  @HiveField(4)
  final int notificationMinute;
  @HiveField(5)
  final bool onboardingCompleted;

  UserPreferences({
    required this.addictionType,
    required this.aiPrompt,
    required this.abstinenceStartDate,
    required this.notificationHour,
    required this.notificationMinute,
    this.onboardingCompleted = false,
  });

  UserPreferences copyWith({
    String? addictionType,
    String? aiPrompt,
    int?    abstinenceStartDate,
    int?    notificationHour,
    int?    notificationMinute,
    bool?   onboardingCompleted,
  }) {
    return UserPreferences(
      addictionType:       addictionType       ?? this.addictionType,
      aiPrompt:            aiPrompt            ?? this.aiPrompt,
      abstinenceStartDate: abstinenceStartDate ?? this.abstinenceStartDate,
      notificationHour:    notificationHour    ?? this.notificationHour,
      notificationMinute:  notificationMinute  ?? this.notificationMinute,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}
