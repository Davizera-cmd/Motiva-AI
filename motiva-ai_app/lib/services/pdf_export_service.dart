import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:motiva_ai/models/diary_entry.dart';

class PdfExportService {
  static Future<void> exportDiary(DiaryEntry entry) async {
    final pdf = pw.Document();

    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Diário de Bordo - Motiva-AI', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Relatório', style: const pw.TextStyle(fontSize: 16)),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Gerado em: ${dateFormat.format(DateTime.now())}',
              style: pw.TextStyle(color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 20),
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        dateFormat.format(DateTime.fromMillisecondsSinceEpoch(entry.dateInMillis)),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'Dificuldade: ${entry.difficulty}',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: _getDifficultyColor(entry.difficulty),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(entry.notes),
                ],
              ),
            ),
          ];
        },
      ),
    );

    final Uint8List bytes = await pdf.save();

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'relato_motiva_ai.pdf',
    );
  }

  static PdfColor _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
        return PdfColors.green;
      case 'médio':
        return PdfColors.orange;
      case 'difícil':
        return PdfColors.red;
      default:
        return PdfColors.black;
    }
  }
}
