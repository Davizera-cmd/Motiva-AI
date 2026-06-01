import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motiva_ai/controllers/diary_controller.dart';
import 'package:motiva_ai/core/constants/app_colors.dart';

/// AddEntryBottomSheet — formulário para adicionar relatos no diário (RF05).
class AddEntryBottomSheet extends StatefulWidget {
  const AddEntryBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder:            (_) => const AddEntryBottomSheet(),
    );
  }

  @override
  State<AddEntryBottomSheet> createState() => _AddEntryBottomSheetState();
}

class _AddEntryBottomSheetState extends State<AddEntryBottomSheet> {
  final _notesCtrl  = TextEditingController();
  String _difficulty = 'Médio';
  bool   _isSaving  = false;

  static const _difficulties = ['Fácil', 'Médio', 'Difícil'];

  @override
  void dispose() { _notesCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await context.read<DiaryController>().addEntry(
      difficulty: _difficulty,
      notes:      _notesCtrl.text.trim(),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      decoration: const BoxDecoration(
        color:        AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize:      MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.grayLight, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Novo Relato', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Como foi hoje?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: _difficulties.map((d) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label:         Text(d),
                  selected:      _difficulty == d,
                  onSelected:    (_) => setState(() => _difficulty = d),
                  showCheckmark: false,
                  selectedColor: AppColors.motivBackground,
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(
                    color: _difficulty == d ? AppColors.motivYellowDark : AppColors.border,
                    width: 2,
                  ),
                  labelStyle:    TextStyle(
                    fontWeight: FontWeight.bold,
                    color:      _difficulty == d ? AppColors.motivYellowDark : AppColors.gray,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller:  _notesCtrl,
            maxLines:    4,
            decoration:  const InputDecoration(hintText: 'Como você se sentiu? (opcional)'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.motivYellowDark,
                side: const BorderSide(color: AppColors.motivYellowDark, width: 2),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child:     _isSaving
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.motivYellowDark))
                  : const Text('Salvar Relato', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
