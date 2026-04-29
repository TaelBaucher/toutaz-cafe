import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toutaz_cafe/Models/SalesModel.dart';
import 'package:toutaz_cafe/Models/firestoreResult.dart';
import 'package:toutaz_cafe/services/sales_service.dart';
import 'package:toutaz_cafe/services/export_service.dart';

class SalesController {
  final SalesService _salesService = SalesService();
  final ExportService _exportService = ExportService();
  final ValueNotifier<Map<String, double>> currentSales = ValueNotifier({});
  StreamSubscription<SalesModel>? _salesSubscription;
  VoidCallback? onSalesUpdated;

  void startListeningToSales({String period = "day"}) {
    _salesSubscription = _salesService.getSales(period).listen((salesModel) {
      currentSales.value = salesModel.sales;
      onSalesUpdated?.call();
    });
  }

  void stopListening() {
    _salesSubscription?.cancel();
  }

  void dispose() {
    stopListening();
    currentSales.dispose();
  }

  Future<FirestoreResult> exportSales({bool currentMonth = false}) async {
    try {
      await _exportService.exportSales(currentMonth: currentMonth);
      return FirestoreResult(success: true);
    } catch (e) {
      return FirestoreResult(success: false, error: e.toString());
    }
  }
}