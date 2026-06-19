import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motiva_ai/controllers/diary_controller.dart';
import 'package:motiva_ai/core/constants/app_colors.dart';

import 'package:motiva_ai/models/diary_entry.dart';

/// AddEntryBottomSheet — formulário para adicionar ou editar relatos no diário (RF05).
class AddEntryBottomSheet extends StatefulWidget {
  final DiaryEntry? entryToEdit;
  const AddEntryBottomSheet({super.key, this.entryToEdit});

  static Future<void> show(BuildContext context, {DiaryEntry? entryToEdit}) {
    return showModalBottomSheet(
      context:            context,
      isScrollControlled: true,
      backgroundColor:    Colors.transparent,
      builder:            (_) => AddEntryBottomSheet(entryToEdit: entryToEdit),
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
  void initState() {
    super.initState();
    if (widget.entryToEdit != null) {
      _difficulty = widget.entryToEdit!.difficulty;
      _notesCtrl.text = widget.entryToEdit!.notes;
    }
  }

  @override
  void dispose() { _notesCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    if (widget.entryToEdit != null) {
      final updatedEntry = DiaryEntry(
        id: widget.entryToEdit!.id,
        dateInMillis: widget.entryToEdit!.dateInMillis,
        difficulty: _difficulty,
        notes: _notesCtrl.text.trim(),
      );
      await context.read<DiaryController>().updateEntry(updatedEntry);
    } else {
      await context.read<DiaryController>().addEntry(
        difficulty: _difficulty,
        notes:      _notesCtrl.text.trim(),
      );
    }
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
          Text(widget.entryToEdit != null ? 'Editar Relato' : 'Novo Relato', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
