import 'package:flutter/material.dart';
import 'package:toutaz_cafe/controllers/salesController.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  late final SalesController _salesController;
  final Map<String, double> sales = {};
  String selectedPeriod = "day";
  double get totalSales => sales.values.fold(0, (sum, value) => sum + value);

  final List<String> types = [
    "Soda",
    "Diabolo",
    "Jus de fruits",
    "Smoothie",
    "Sirop",
    "Thé",
    "Café",
    "Chocolat",
    "Snack salé",
    "Snack sucré"
  ];

  @override
  void initState() {
    super.initState();
    _salesController = SalesController();
    _salesController.startListeningToSales();

    _salesController.onSalesUpdated = () {
      setState(() {});
    };

    _salesController.currentSales.addListener(() {
      sales.clear();
      sales.addAll(_salesController.currentSales.value);
    });
  }

  @override
  void dispose() {
    _salesController.dispose();
    super.dispose();
  }

  void _changePeriod(String period) {
    setState(() {
      selectedPeriod = period;
      _salesController.stopListening();
      _salesController.startListeningToSales(period: selectedPeriod);
    });
  }

  void _extractSales() async {
    final result = await _salesController.exportSales();

    if (!mounted) return;

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: ${result.error}"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          showCloseIcon: true,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ventes extraites !'),
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _periodButton(String period, String label) {
    return TextButton(
      onPressed: () => _changePeriod(period),
      style: TextButton.styleFrom(
        backgroundColor:
            selectedPeriod == period ? Colors.grey[300] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comptes")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _periodButton("day", "Jour"),
              _periodButton("week", "Semaine"),
              _periodButton("month", "Mois"),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: types.length,
              itemBuilder: (context, index) {
                String item = types[index];
                double total = sales[item] ?? 0;

                return Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(item, style: const TextStyle(fontSize: 18)),
                      ),
                      Expanded(
                        child: Text(
                          '${total.toStringAsFixed(2)} €',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.deepPurple.shade100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: const Text(
                        "Total:",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${totalSales.toStringAsFixed(2)}€",
                        style: const TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _extractSales,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: Colors.deepPurple.withValues(alpha: 0.4),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("Extraire"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
