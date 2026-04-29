import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /*
  // Export the sales of the previous month to an Excel file and share it
  //
  // @return void
  // @throw Exception: if no sales are found or if an error occurs during export
   */
  Future<void> exportSales({bool currentMonth = false}) async {
    try {
      final now = DateTime.now();
      final targetMonth = currentMonth 
          ? DateTime(now.year, now.month, 1)
          : DateTime(now.year, now.month - 1, 1);
      final start = DateTime(targetMonth.year, targetMonth.month, 1);
      final end = DateTime(targetMonth.year, targetMonth.month + 1, 1);

      final snapshot = await _firestore
          .collection('sales')
          .where('timestamp', isGreaterThanOrEqualTo: start)
          .where('timestamp', isLessThan: end)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception("Aucune vente trouvée pour cette période");
      }

      final Map<String, Map<String, dynamic>> salesSummary = {};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final type = data['type'];
        final quantity = (data['quantity'] ?? 0) as int;
        final total = (data['total'] ?? 0).toDouble();

        if (!salesSummary.containsKey(type)) {
          salesSummary[type] = {"quantity": 0, "total": 0.0};
        }

        salesSummary[type]!["quantity"] += quantity;
        salesSummary[type]!["total"] += total;
      }

      final excel = Excel.createExcel();
      final sheetName =
          "Ventes ${targetMonth.month}/${targetMonth.year.toString().substring(2)}";

      if (excel.sheets.containsKey("Sheet1")) {
        excel.rename("Sheet1", sheetName);
      }

      final sheet = excel[sheetName];

      final title =
          "Ventes ${targetMonth.month.toString().padLeft(2, '0')}/${targetMonth.year.toString().substring(2)}";

      sheet.appendRow([TextCellValue(title)]);
      sheet.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("C1"),
          customValue: TextCellValue(title));
      sheet.cell(CellIndex.indexByString("A1")).cellStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        bold: true,
      );

      sheet.appendRow([
        TextCellValue("Type"),
        TextCellValue("Quantité"),
        TextCellValue("Total (€)")
      ]);

      double globalTotal = 0.0;

      salesSummary.forEach((type, data) {
        sheet.appendRow([
          TextCellValue(type),
          IntCellValue(data["quantity"] as int),
          TextCellValue("${data["total"].toStringAsFixed(2)} €"),
        ]);
        globalTotal += data["total"];
      });

      sheet.appendRow([
        TextCellValue("Total"),
        TextCellValue(""),
        TextCellValue("${globalTotal.toStringAsFixed(2)} €")
      ]);

      final totalRowIndex = salesSummary.length + 3;
      final CellStyle totalStyle = CellStyle(
        backgroundColorHex: ExcelColor.fromHexString("#FF0000"),
        fontColorHex: ExcelColor.fromHexString("#FFFFFF"),
        bold: true,
      );
      sheet.cell(CellIndex.indexByString("A$totalRowIndex")).cellStyle =
          totalStyle;
      sheet.cell(CellIndex.indexByString("C$totalRowIndex")).cellStyle =
          totalStyle;

      final fileName = 'ventes_${targetMonth.month}_${targetMonth.year}.xlsx';

      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final path = '${dir?.path ?? ""}/$fileName';
      final file = File(path);
      final bytes = excel.encode();

      if (bytes != null) {
        await file.writeAsBytes(bytes);
        await Share.shareXFiles([XFile(file.path)], text: 'Export des ventes');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
