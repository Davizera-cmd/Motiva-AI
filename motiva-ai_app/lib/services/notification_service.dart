import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (kIsWeb) {
      debugPrint('Notificações nativas não suportadas no Web (Chrome)');
      return;
    }
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));
    } catch (e) {
      debugPrint('Não foi possível configurar timezone local. Usando fallback. Erro: $e');
    }

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
      },
    );

    await requestPermissions();
  }

  static Future<void> showInstantNotification({String? title, String? body}) async {
    if (kIsWeb) return;

    final bigTextStyle = BigTextStyleInformation(
      body ?? 'Seu lembrete diário foi agendado com sucesso!',
      contentTitle: title ?? 'Motiva-AI',
    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'motiva_ai_instant',
      'Notificações Instantâneas',
      channelDescription: 'Notificações de teste e confirmação imediata',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigTextStyle,
    );

    final platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      id: 99,
      title: title ?? 'Motiva-AI',
      body: body ?? 'Seu lembrete diário foi agendado com sucesso!',
      notificationDetails: platformChannelSpecifics,
    );
  }

  static Future<void> requestPermissions() async {
    if (kIsWeb) return;
    final androidImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();
  }

  static Future<void> scheduleDailyNotification(int hour, int minute) async {
    if (kIsWeb) return;
    try {
      tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));
    } catch (e) {
      debugPrint('Erro ao configurar timezone: $e');
    }
    
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final bigTextStyle = BigTextStyleInformation(
      'Lembre-se de verificar seu progresso e escrever no diário hoje!',
      contentTitle: 'Motiva-AI',
    );

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'motiva_ai_daily',
      'Lembrete Diário',
      channelDescription: 'Lembrete diário para registrar no diário e ver o apoio da IA',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      styleInformation: bigTextStyle,
    );

    final platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.zonedSchedule(
      id: 0,
      title: 'Motiva-AI',
      body: 'Lembre-se de verificar seu progresso e escrever no diário hoje!',
      scheduledDate: scheduledDate,
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
