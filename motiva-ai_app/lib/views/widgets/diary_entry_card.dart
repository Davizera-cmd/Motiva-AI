import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motiva_ai/models/diary_entry.dart';
import 'package:motiva_ai/core/constants/app_colors.dart';
import 'package:motiva_ai/controllers/diary_controller.dart';
import 'package:motiva_ai/views/widgets/add_entry_bottom_sheet.dart';

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
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20, color: AppColors.gray),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [Icon(Icons.edit_outlined, size: 18), SizedBox(width: 8), Text('Editar')]),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [Icon(Icons.delete_outline, size: 18, color: AppColors.error), SizedBox(width: 8), Text('Excluir', style: TextStyle(color: AppColors.error))]),
                    ),
                  ],
                  onSelected: (value) async {
                    if (value == 'edit') {
                      AddEntryBottomSheet.show(context, entryToEdit: entry);
                    } else if (value == 'delete') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Text('Excluir Relato', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: const Text('Tem certeza que deseja excluir este relato permanentemente?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar', style: TextStyle(color: AppColors.gray, fontWeight: FontWeight.bold)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: AppColors.white,
                                elevation: 0,
                              ),
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Excluir', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        context.read<DiaryController>().deleteEntry(entry.id);
                      }
                    }
                  },
                ),
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
