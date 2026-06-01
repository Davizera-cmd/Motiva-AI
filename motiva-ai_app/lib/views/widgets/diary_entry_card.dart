import 'package:flutter/material.dart';
import 'package:motiva_ai/models/diary_entry.dart';
import 'package:motiva_ai/core/constants/app_colors.dart';

/// DiaryEntryCard — card de relato do diário (RF05).
class DiaryEntryCard extends StatelessWidget {
  final DiaryEntry entry;
  const DiaryEntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _formatDate(entry.dateInMillis),
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const Spacer(),
                _DifficultyBadge(difficulty: entry.difficulty),
              ],
            ),
            if (entry.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                entry.notes,
                style: const TextStyle(fontSize: 14, color: AppColors.motivTextBlack, height: 1.5),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(int ms) {
    final dt = DateTime.fromMillisecondsSinceEpoch(ms);
    final p  = (int n) => n.toString().padLeft(2, '0');
    return '${p(dt.day)}/${p(dt.month)}/${dt.year}  ${p(dt.hour)}:${p(dt.minute)}';
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;
  const _DifficultyBadge({required this.difficulty});

  Color get _color => switch (difficulty) {
    'Fácil'   => AppColors.success,
    'Difícil' => AppColors.error,
    _          => const Color(0xFFFF8F00),
  };

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color:        _color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      difficulty,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _color),
    ),
  );
}
