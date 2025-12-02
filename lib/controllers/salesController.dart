import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toutaz_cafe/Models/SalesModel.dart';
import 'package:toutaz_cafe/Models/firestoreResult.dart';
import 'package:toutaz_cafe/services/service.dart';

class SalesController {
  final Service _service = Service();
  final ValueNotifier<Map<String, double>> currentSales = ValueNotifier({});
  StreamSubscription<SalesModel>? _salesSubscription;
  VoidCallback? onSalesUpdated;

  void startListeningToSales({String period = "day"}) {
    _salesSubscription = _service.getSales(period).listen((salesModel) {
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

  Future<FirestoreResult> exportSales() async {
    try {
      await _service.exportSales();
      return FirestoreResult(success: true);
    } catch (e) {
      return FirestoreResult(success: false, error: e.toString());
    }
  }
}