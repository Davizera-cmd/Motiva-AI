import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motiva_ai/controllers/abstinence_controller.dart';
import 'package:motiva_ai/core/constants/app_colors.dart';

class AbstinenceCounterWidget extends StatelessWidget {
  const AbstinenceCounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AbstinenceController>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular Progress (Design similar ao HTML)
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: 1.0, // Fundo cinza
                  strokeWidth: 12,
                  backgroundColor: AppColors.grayLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.grayLight),
                ),
              ),
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: 0.43, // Exemplo fixo do HTML, depois podemos tornar dinâmico
                  strokeWidth: 12,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.motivYellow),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${ctrl.days}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.motivYellowDark,
                    ),
                  ),
                  const Text(
                    'Dias',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Estou no controle agora!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.motivTextBlack,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: AppColors.grayLight),
          ),
          const Text(
            'TEMPO DE ABSTINÊNCIA DESDE O REINÍCIO',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.gray,
              letterSpacing: 0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              _TimerUnit(value: ctrl.days, unit: 'dias'),
              const Text(', ', style: TextStyle(fontSize: 16)),
              _TimerUnit(value: ctrl.hours, unit: 'hr'),
              const Text(', ', style: TextStyle(fontSize: 16)),
              _TimerUnit(value: ctrl.minutes, unit: 'min'),
              const Text(', ', style: TextStyle(fontSize: 16)),
              _TimerUnit(value: ctrl.seconds, unit: 'seg'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerUnit extends StatelessWidget {
  final int value;
  final String unit;
  const _TimerUnit({required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '$value',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 2),
        Text(
          unit,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
