import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:motiva_ai/controllers/onboarding_controller.dart';
import 'package:motiva_ai/core/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onCompleted;
  const OnboardingScreen({super.key, required this.onCompleted});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _addictionCtrl = TextEditingController();
  final _toneCtrl      = TextEditingController();
  DateTime? _startDate;
  TimeOfDay? _notifTime;
  bool _isSaving = false;

  @override
  void dispose() {
    _addictionCtrl.dispose();
    _toneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
    if (date == null) return;
    setState(() => _startDate = date);
  }

  Future<void> _pickNotifTime() async {
    final time = await showTimePicker(
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
    if (time == null) return;
    setState(() => _notifTime = time);
  }

  bool get _isValid =>
      _addictionCtrl.text.trim().isNotEmpty &&
      _toneCtrl.text.trim().isNotEmpty &&
      _startDate != null &&
      _notifTime != null;

  Future<void> _handleComplete() async {
    if (!_isValid) return;
    setState(() => _isSaving = true);
    await OnboardingController.completeOnboarding(
      addictionType: _addictionCtrl.text.trim(),
      aiPrompt: _toneCtrl.text.trim(),
      abstinenceStartDate: _startDate!.millisecondsSinceEpoch,
      notificationHour: _notifTime!.hour,
      notificationMinute: _notifTime!.minute,
    );
    widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.motivBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Sutil Header Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.eco, color: AppColors.motivYellowDark, size: 24),
                      const SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          children: const [
                            TextSpan(text: 'Motiva-', style: TextStyle(color: AppColors.motivTextBlack)),
                            TextSpan(text: 'AI', style: TextStyle(color: AppColors.motivYellowDark)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Configure seu companheiro de IA.',
                    style: GoogleFonts.lato(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            
            // Form Section
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -5))
                  ],
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(), // Melhor para telas pequenas
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInputGroup(
                        label: 'Qual vício vamos combater?',
                        icon: Icons.block,
                        child: TextField(
                          controller: _addictionCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: _inputDecoration('Ex: Álcool, Cigarro...'),
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildInputGroup(
                        label: 'Data de início da abstinência',
                        icon: Icons.calendar_month,
                        child: InkWell(
                          onTap: _pickStartDate,
                          borderRadius: BorderRadius.circular(16),
                          child: _fakeInput(
                            text: _startDate == null 
                                ? 'Selecionar data' 
                                : "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}",
                            isPlaceholder: _startDate == null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildInputGroup(
                        label: 'Horário do lembrete diário',
                        icon: Icons.notifications,
                        child: InkWell(
                          onTap: _pickNotifTime,
                          borderRadius: BorderRadius.circular(16),
                          child: _fakeInput(
                            text: _notifTime == null ? 'Selecionar horário' : _notifTime!.format(context),
                            isPlaceholder: _notifTime == null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildInputGroup(
                        label: 'Como a IA deve falar com você?',
                        icon: Icons.smart_toy,
                        child: TextField(
                          controller: _toneCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: _inputDecoration('Ex: Acolhedor, Firme...'),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Iniciar Button
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: (_isValid && !_isSaving) ? _handleComplete : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.motivYellowDark,
                            foregroundColor: AppColors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _isSaving 
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Iniciar Jornada',
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.rocket_launch, size: 18),
                                ],
                              ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputGroup({required String label, required IconData icon, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.motivTextBlack),
        ),
        const SizedBox(height: 6),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            child,
            Padding(
              padding: const EdgeInsets.only(left: 15),
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
}
