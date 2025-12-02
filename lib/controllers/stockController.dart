import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toutaz_cafe/Models/StockModel.dart';
import 'package:toutaz_cafe/Models/firestoreResult.dart';
import 'package:toutaz_cafe/services/service.dart';

class StockController {
  final Service _service = Service();
  final ValueNotifier<Map<String, int>> currentStocks = ValueNotifier({});
  StreamSubscription<StockModel>? _stocksSubscription;
  VoidCallback? onStockUpdated;

  Future<void> restockItems(Map<String, int> items) async {
    await _service.restockItems(items);
  }

  Future<FirestoreResult> consumeItem(String item, int quantity) async {
    try {
      await _service.consumeItem(item, quantity);
      return FirestoreResult(success: true);
    } catch (e) {
      return FirestoreResult(success: false, error: e.toString());
    }
  }

  void startListeningToStocks() {
    _stocksSubscription = _service.getStocks().listen((stockModel) {
      currentStocks.value = stockModel.stocks;
      onStockUpdated?.call();
    });
  }

  void stopListening() {
    _stocksSubscription?.cancel();
  }

  void dispose() {
    stopListening();
    currentStocks.dispose();
  }
}