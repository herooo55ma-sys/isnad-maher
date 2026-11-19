import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models.dart';

class PdfGenerator {
  static Future<pw.Font> _loadFont() async {
    final data = await rootBundle.load('assets/fonts/Amiri-Regular.ttf');
    return pw.Font.ttf(data);
  }

  static Future<File> generate(List<IsnadRecord> records, {String? title}) async {
    final font = await _loadFont();
    final pdf = pw.Document();
    final now = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        textDirection: pw.TextDirection.rtl,
        build: (ctx) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('إسناد ماهر',
                  style: pw.TextStyle(font: font, fontSize: 26, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              pw.Text(title ?? 'تقرير متابعة التكاليف والمكاتبات',
                  style: pw.TextStyle(font: font, fontSize: 14)),
              pw.Text('تاريخ الإصدار: $now',
                  style: pw.TextStyle(font: font, fontSize: 10)),
              pw.Text('عدد السجلات: ${records.length}',
                  style: pw.TextStyle(font: font, fontSize: 10)),
              pw.SizedBox(height: 12),
            ],
          ),
          pw.TableHelper.fromTextArray(
            headers: ['اسم التكلفة', 'رقم المكاتبة', 'جهة الصدور', 'المكلف', 'الهاتف', 'الموقف', 'التاريخ'],
            data: records
                .map((r) => [r.costName, r.letterNumber, r.issuer, r.assignee, r.phone, r.status, r.statusDate])
                .toList(),
            headerStyle: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold, fontSize: 11),
            cellStyle: pw.TextStyle(font: font, fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.teal200),
            cellAlignment: pw.Alignment.center,
            headerAlignment: pw.Alignment.center,
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
        '${dir.path}/تقرير_اسناد_ماهر_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<void> printPdf(File file) async {
    await Printing.layoutPdf(onLayout: (_) => file.readAsBytes());
  }

  static Future<void> sharePdf(File file) async {
    await Printing.sharePdf(
      bytes: await file.readAsBytes(),
      filename: file.path.split('/').last,
    );
  }
}
