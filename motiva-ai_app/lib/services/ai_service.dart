import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:motiva_ai/services/notification_service.dart';

class AIService {

  static String get _baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:3000';

  static Future<String> generateMotivationalMessage({
    required String addictionType,
    required String aiPrompt,
    required int daysAbstinent,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/motivate');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'addictionType': addictionType,
          'aiPrompt': aiPrompt,
          'daysAbstinent': daysAbstinent,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['message'] as String? ?? _fallback(addictionType);
      }
      return _fallback(addictionType);
    } catch (e) {
      debugPrint('[AIService] Erro de rede: $e');
      return _fallback(addictionType);
    }
  }

  static Future<void> triggerAIPredictionNotification({
    required String addictionType,
    required String aiPrompt,
    required int daysAbstinent,
  }) async {
    final message = await generateMotivationalMessage(
      addictionType: addictionType,
      aiPrompt: aiPrompt,
      daysAbstinent: daysAbstinent,
    );
    await NotificationService.showInstantNotification(
      title: 'Sua mensagem diária chegou',
      body: message,
    );
  }

  static String _fallback(String type) {
    const msgs = [
      'Cada passo conta. Você está fazendo algo extraordinário!',
      'A força que você tem é maior do que qualquer vício.',
      'Você já provou que é capaz. Continue firme na jornada!',
    ];
    return msgs[DateTime.now().second % msgs.length];
  }
}
