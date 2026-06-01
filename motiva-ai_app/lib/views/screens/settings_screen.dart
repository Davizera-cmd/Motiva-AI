import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:motiva_ai/controllers/abstinence_controller.dart';
import 'package:motiva_ai/controllers/onboarding_controller.dart';
import 'package:motiva_ai/core/constants/app_colors.dart';
import 'package:motiva_ai/services/ai_service.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onBack;
  const SettingsScreen({super.key, required this.onBack});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _addictionCtrl;
  late TextEditingController _promptCtrl;
  TimeOfDay? _notifTime;

  @override
  void initState() {
    super.initState();
    final prefs = context.read<AbstinenceController>().preferences;
    _addictionCtrl = TextEditingController(text: prefs?.addictionType ?? '');
    _promptCtrl = TextEditingController(text: prefs?.aiPrompt ?? '');
    if (prefs != null) {
      _notifTime = TimeOfDay(hour: prefs.notificationHour, minute: prefs.notificationMinute);
    }
  }

  Future<void> _handleSave() async {
    if (_notifTime == null) return;
    final prefs = context.read<AbstinenceController>().preferences!;
    await OnboardingController.updateSettings(
      current: prefs,
      addictionType: _addictionCtrl.text,
      aiPrompt: _promptCtrl.text,
      notificationHour: _notifTime!.hour,
      notificationMinute: _notifTime!.minute,
    );
    await context.read<AbstinenceController>().load();
  }

  Widget _buildInputGroup({required String label, required IconData icon, required Widget child, bool alignTop = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.motivTextBlack)),
        const SizedBox(height: 8),
        Stack(
          alignment: alignTop ? Alignment.topLeft : Alignment.centerLeft,
          children: [
            child,
            Padding(
              padding: EdgeInsets.only(left: 15, top: alignTop ? 14 : 0),
              child: Icon(icon, size: 16, color: AppColors.motivYellowDark),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.lato(color: AppColors.gray, fontSize: 14),
      contentPadding: const EdgeInsets.fromLTRB(42, 14, 15, 14),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.grayLight, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.grayLight, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.motivYellow, width: 2),
      ),
    );
  }

  Widget _fakeInput({required String text, bool isPlaceholder = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(42, 14, 15, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayLight, width: 2),
      ),
      child: Text(
        text,
        style: GoogleFonts.lato(
          fontSize: 14,
          color: isPlaceholder ? AppColors.gray : AppColors.motivTextBlack,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<AbstinenceController>().preferences;
    
    // Sincroniza valores assim que as preferências são carregadas
    if (prefs != null && _notifTime == null) {
      _addictionCtrl.text = prefs.addictionType;
      _promptCtrl.text = prefs.aiPrompt;
      _notifTime = TimeOfDay(hour: prefs.notificationHour, minute: prefs.notificationMinute);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInputGroup(
            label: 'Seu Vício / Foco',
            icon: Icons.block,
            child: TextField(
              controller: _addictionCtrl,
              onChanged: (_) => _handleSave(),
              decoration: _inputDecoration('Ex: Álcool, Cigarro...'),
            ),
          ),
          const SizedBox(height: 24),
          _buildInputGroup(
            label: 'Como a IA deve falar com você?',
            icon: Icons.smart_toy,
            alignTop: true,
            child: TextField(
              controller: _promptCtrl,
              maxLines: 3,
              onChanged: (_) => _handleSave(),
              decoration: _inputDecoration('Ex: Seja motivador e use gírias...'),
            ),
          ),
          const SizedBox(height: 24),
          _buildInputGroup(
            label: 'Horário do lembrete diário',
            icon: Icons.notifications,
            child: InkWell(
              onTap: () async {
                final t = await showTimePicker(
                  context: context, 
                  initialTime: _notifTime ?? const TimeOfDay(hour: 9, minute: 0),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light(useMaterial3: true).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.motivYellowDark,
                          onPrimary: AppColors.white,
                          primaryContainer: AppColors.motivYellowDark,
                          onPrimaryContainer: AppColors.white,
                          surface: AppColors.white,
                          onSurface: AppColors.motivTextBlack,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.motivYellowDark,
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (t != null) {
                  setState(() => _notifTime = t);
                  await _handleSave();
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: _fakeInput(
                text: _notifTime == null ? 'Selecionar horário' : _notifTime!.format(context),
                isPlaceholder: _notifTime == null,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
              final prefs = context.read<AbstinenceController>().preferences;
              final days = context.read<AbstinenceController>().days;
              await AIService.triggerAIPredictionNotification(
                addictionType: prefs?.addictionType ?? 'Vício',
                aiPrompt: prefs?.aiPrompt ?? 'Seja motivador',
                daysAbstinent: days,
              );
            },
            icon: const Icon(Icons.notifications_active),
            label: const Text('Testar Notificação Agora'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.motivYellow,
              foregroundColor: AppColors.motivTextBlack,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
}
