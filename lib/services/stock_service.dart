import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toutaz_cafe/Models/StockModel.dart';

class StockService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

}
