import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toutaz_cafe/Models/SalesModel.dart';

class SalesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<SalesModel> getSales(String period) {
    final now = DateTime.now();

    DateTime start;
    if (period == "day") {
      start = DateTime(now.year, now.month, now.day);
    } else if (period == "week") {
      start = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
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
}
