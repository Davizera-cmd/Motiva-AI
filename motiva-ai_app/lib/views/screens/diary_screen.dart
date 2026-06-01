import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motiva_ai/controllers/abstinence_controller.dart';
import 'package:motiva_ai/controllers/diary_controller.dart';
import 'package:motiva_ai/core/constants/app_colors.dart';
import 'package:motiva_ai/views/widgets/diary_entry_card.dart';
import 'package:motiva_ai/views/widgets/add_entry_bottom_sheet.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<DiaryController>().entries;

    return Scaffold(
      backgroundColor: AppColors.appBg,
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<AbstinenceController>().load();
          await context.read<DiaryController>().load();
        },
        child: entries.isEmpty
            ? CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_note_rounded, size: 64, color: AppColors.grayLight),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhum relato ainda.',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.motivTextBlack),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Escreva sobre como você está se sentindo hoje.',
                            style: TextStyle(color: AppColors.gray),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // padding bottom for FAB
                itemCount: entries.length,
                itemBuilder: (context, index) => DiaryEntryCard(entry: entries[index]),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.white, // Fundo branco
        foregroundColor: AppColors.motivYellowDark, // Texto e ícone amarelo como a navegação
        elevation: 2,
        icon: const Icon(Icons.add),
        label: const Text('Novo Relato', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => AddEntryBottomSheet.show(context),
      ),
    );
  }
}
