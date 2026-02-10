import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toutaz_cafe/Models/SalesModel.dart';
import 'package:toutaz_cafe/Models/StockModel.dart';

class Service {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /*
  // Add items to the stock
  //
  // @parameter Map<String, int> items: a map of items to add to the stock
  //
  // @return void
   */
  Future<void> restockItems(Map<String, int> items) async {
    final batch = _firestore.batch();

    for (final entry in items.entries) {
      final item = entry.key;
      final quantity = entry.value;

      final docRef = _firestore.collection("stocks").doc(item);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        final curQuantity = snapshot.data()?["quantity"] ?? 0;
        final newQuantity = curQuantity + quantity;

        batch.update(docRef, {"quantity": newQuantity});
      } else {
        batch.set(docRef, {"name": item, "quantity": quantity});
      }
    }

    await batch.commit();
  }

  /*
  // take an amount of item and remove it from the stocks and create a sale
  //
  // @parameter String item: the item's name sell
  // @parameter int quantity; the amount of the item sell
  //
  // @return void
  // @throw Exception: if the item doesn't exist or stoks too low
   */
  Future<void> consumeItem(String item, int quantity) async {
    final stockRef = _firestore.collection("stocks").doc(item);
    final salesRef = _firestore.collection("sales").doc();

    final now = DateTime.now();

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(stockRef);

      if (!snapshot.exists) {
        throw Exception("$item introuvable");
      }

      final data = snapshot.data() as Map<String, dynamic>;
      final price = data["price"] ?? 0;
      final type = data["type"] ?? 0;

      if (data.containsKey("quantity")) {
        final curStock = data["quantity"];

        if (curStock < quantity) {
          throw Exception("Stock de $item insuffisant");
        }

        transaction.update(stockRef, {"quantity": curStock - quantity});
      }

      transaction.set(salesRef, {
        "timestamp": now,
        "type": type,
        "total": price * quantity,
        "quantity": quantity
      });
    });
  }

  /*
  // Get the list of stocks
  //
  // @return Stream<StockModel>: a stream of StockModel
   */
  Stream<StockModel> getStocks() {
    return _firestore.collection('stocks').snapshots().map((snapshot) {
      final Map<String, int> stocksMap = {};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final name = doc.id;

        if (data.containsKey("quantity")) {
          final quantity = data['quantity'] ?? 0;
          stocksMap[name] = quantity;
        } else {
          stocksMap[name] = -1;
        }
      }
      return StockModel(stocks: stocksMap);
    });
  }

  /*
  // Get the list of sales for a specific period
  //
  // @parameter String period: the period to filter the sales (day, week, month)
  //
  // @return Stream<SalesModel>: a stream of SalesModel
   */
  Stream<SalesModel> getSales(String period) {
    final now = DateTime.now();

    DateTime start;
    if (period == "day") {
      start = DateTime(now.year, now.month, now.day);
    } else if (period == "week") {
      start = now.subtract(Duration(days: now.weekday - 1));
    } else {
      start = DateTime(now.year, now.month, 1);
    }

    return _firestore
        .collection('sales')
        .where("timestamp", isGreaterThanOrEqualTo: start)
        .snapshots()
        .map((snapshot) {
      final Map<String, double> salesMap = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final total = (data["total"] as num).toDouble();
        final type = data["type"] as String;

        salesMap[type] = (salesMap[type] ?? 0) + total;
      }

      return SalesModel(sales: salesMap);
    });
  }

  /*
  // Add a new product to the stock
  //
  // @parameter String name: the name of the product
  // @parameter String type: the type of the product
  // @parameter double price: the price of the product
  //
  // @return void
  // @throw Exception: if the product cannot be added
   */
  Future<void> addProduct(String name, String type, double price) async {
    try {
      await _firestore
          .collection("stocks")
          .doc(name)
          .set({"name": name, "type": type, "price": price, "quantity": 0});
    } catch (e) {
      throw Exception("Impossible d'ajouter le produit suivant: $name");
    }
  }

  /*
  // Remove a product from the stock
  //
  // @parameter String name: the name of the product to remove
  //
  // @return void
  // @throw Exception: if the product cannot be removed
   */
  Future<void> retireProduct(String name) async {
    try {
      await _firestore.collection("stocks").doc(name).delete();
    } catch (e) {
      throw Exception("Impossible de supprimer le produit suivant: $name");
    }
  }

  /*
  // Change the quantity of a product in the stock
  //
  // @parameter String name: the name of the product
  // @parameter int quantity: the new quantity of the product
  //
  // @return void
  // @throw Exception: if the stock cannot be changed
   */
  Future<void> changeStock(String name, int quantity) async {
    try {
      await _firestore
          .collection("stocks")
          .doc(name)
          .update({"quantity": quantity});
    } catch (e) {
      throw Exception(
          "Impossible de changer le stock du produit suivant: $name");
    }
  }

  /*
  // Change the price of a product
  //
  // @parameter String name: the name of the product
  // @parameter double price: the new price of the product
  //
  // @return void
  // @throw Exception: if the price cannot be changed
   */
  Future<void> changePrice(String name, double price) async {
    try {
      await _firestore.collection("stocks").doc(name).update({"price": price});
    } catch (e) {
      throw Exception(
          "Impossible de changer le stock du produit suivant: $name");
    }
  }

  /*
  // Change the name of a product
  //
  // @parameter String name: the current name of the product
  // @parameter String newName: the new name of the product
  //
  // @return void
  // @throw Exception: if the name cannot be changed or if the product doesn't exist
   */
  Future<void> changeName(String name, String newName) async {
    try {
      final oldDoc = await _firestore.collection("stocks").doc(name).get();

      if (!oldDoc.exists) {
        throw Exception(
            "Impossible de changer le nom du produit suivant: $name");
      }

      await _firestore.collection("stocks").doc(newName).set(oldDoc.data()!);
      await _firestore.collection("stocks").doc(name).delete();
    } catch (e) {
      throw Exception("Impossible de changer le nom du produit suivant: $name");
    }
  }

  /*
  // Fetch the password from the configuration
  //
  // @return Future<String?>: the password
   */
  Future<String?> fetchPassword() async {
    final doc = await _firestore.collection('config').doc('settings').get();
    return doc.data()?['password'];
  }

  /*
  // Update the password in the configuration
  //
  // @parameter String newPassword: the new password
  //
  // @return void
  // @throw Exception: if the password cannot be updated
   */
  Future<void> updatePassword(String newPassword) async {
    try {
      await _firestore.collection('config').doc('settings').update({
        'password': newPassword,
      });
    } catch (e) {
      throw Exception("Impossible de mettre à jour le mot de passe");
    }
  }

  /*
  // Export the sales of the previous month to an Excel file and share it
  //
  // @return void
  // @throw Exception: if no sales are found or if an error occurs during export
   */
  Future<void> exportSales() async {
    try {
      final now = DateTime.now();
      final lastMonth = DateTime(now.year, now.month - 1, 1);
      final start = DateTime(lastMonth.year, lastMonth.month, 1);
      final end = DateTime(lastMonth.year, lastMonth.month + 1, 1);

      final snapshot = await _firestore
          .collection('sales')
          .where('timestamp', isGreaterThanOrEqualTo: start)
          .where('timestamp', isLessThan: end)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception("Aucune vente trouvé pour le mois précédent");
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
          "Ventes ${lastMonth.month}/${lastMonth.year.toString().substring(2)}";

      if (excel.sheets.containsKey("Sheet1")) {
        excel.rename("Sheet1", sheetName);
      }

      final sheet = excel[sheetName];

      final title =
          "Ventes ${lastMonth.month.toString().padLeft(2, '0')}/${lastMonth.year.toString().substring(2)}";

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

      final fileName = 'ventes_${lastMonth.month}_${lastMonth.year}.xlsx';

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
