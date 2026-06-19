import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:motiva_ai/controllers/abstinence_controller.dart';
import 'package:motiva_ai/controllers/diary_controller.dart';
import 'package:motiva_ai/core/constants/app_colors.dart';
import 'package:motiva_ai/views/widgets/abstinence_counter_widget.dart';
import 'package:motiva_ai/views/screens/settings_screen.dart';
import 'package:motiva_ai/views/screens/diary_screen.dart';
import 'package:motiva_ai/services/pdf_export_service.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onSettingsTap;
  const MainScreen({super.key, required this.onSettingsTap});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Timer? _ticker;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AbstinenceController>().load();
      context.read<DiaryController>().load();
    });
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => context.read<AbstinenceController>().tick());
  }

  @override
  void dispose() { _ticker?.cancel(); super.dispose(); }

  Future<void> _handleReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: AppColors.errorLight, shape: BoxShape.circle),
                child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 32),
              ),
              const SizedBox(height: 20),
              const Text(
                'Marcar Recaída?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.motivTextBlack),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Isso zerará o seu contador de abstinência atual. Deseja realmente recomeçar sua jornada?',
                style: TextStyle(fontSize: 15, color: AppColors.gray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar', style: TextStyle(color: AppColors.gray, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Sim, recomeçar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed == true) await context.read<AbstinenceController>().resetCounter();
  }



  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<AbstinenceController>().preferences;
    final addictionName = prefs?.addictionType ?? 'Vício';

    return Scaffold(
      backgroundColor: AppColors.appBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.grayLight, height: 1.0),
        ),
        title: Text(
          _currentIndex == 0 ? 'Resumo ($addictionName)' : _currentIndex == 1 ? 'Diário' : 'Configurações',
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.motivTextBlack),
        ),
        centerTitle: true,
        actions: [
          if (_currentIndex == 1)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf, color: AppColors.motivTextBlack),
              tooltip: 'Exportar Diário',
              onPressed: () async {
                final dateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.motivYellowDark,
                          onPrimary: Colors.white,
                          onSurface: AppColors.motivTextBlack,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (dateRange != null && context.mounted) {
                  final allEntries = context.read<DiaryController>().entries;
                  final startDate = dateRange.start;
                  final endDate = DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day, 23, 59, 59);

                  final filtered = allEntries.where((e) {
                    final d = DateTime.fromMillisecondsSinceEpoch(e.dateInMillis);
                    return d.isAfter(startDate.subtract(const Duration(seconds: 1))) && d.isBefore(endDate.add(const Duration(seconds: 1)));
                  }).toList();

                  if (filtered.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nenhum relato encontrado neste período.')),
                    );
                  } else {
                    await PdfExportService.exportDiary(filtered, startDate, dateRange.end);
                  }
                }
              },
            ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildSummaryView(),
          const DiaryScreen(),
          SettingsScreen(onBack: () => setState(() => _currentIndex = 0)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.motivYellowDark,
        unselectedItemColor: AppColors.gray,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Resumo'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Diário'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Ajustes'),
        ],
      ),
    );
  }

  Widget _buildSummaryView() {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<AbstinenceController>().load();
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const AbstinenceCounterWidget(),
                const SizedBox(height: 16),
                Center(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.warning_amber, color: AppColors.error),
                    label: const Text('Marcar Recaída', style: TextStyle(color: AppColors.error)),
                    onPressed: _handleReset,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      side: const BorderSide(color: AppColors.errorLight),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }


}
