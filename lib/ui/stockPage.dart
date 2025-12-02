import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toutaz_cafe/controllers/stockController.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late final StockController _stockController;
  Map<String, int> stock = {};
  Map<String, int> counters = {};
  List<String> items = [];
  Timer? holdTimer;

  @override
  void initState() {
    super.initState();
    _stockController = StockController();
    _stockController.startListeningToStocks();

    _stockController.onStockUpdated = () {
      setState(() {});
    };

    _stockController.currentStocks.addListener(() {
      setState(() {
        stock = Map.fromEntries(
          _stockController.currentStocks.value.entries
            .where((entry) => entry.value >= 0)
        );
        items = stock.keys.toList();
        for (var item in items) {
          counters.putIfAbsent(item, () => 0);
        }
      });
    });
  }

  @override
  void dispose() {
    _stockController.dispose();
    super.dispose();
  }

  void incrementCounter(String item) {
    setState(() {
      counters[item] = (counters[item] ?? 0) + 1;
    });
  }

  void decrementCounter(String item) {
    setState(() {
      if ((counters[item] ?? 0) > 0) {
        counters[item] = (counters[item] ?? 0) - 1;
      }
    });
  }

  void validateAllAdditions() async {
    final additions = Map.fromEntries(
      counters.entries.where((entry) => entry.value > 0)
    );

    if (additions.isEmpty) return;

    await _stockController.restockItems(additions);

    setState(() {
      for (var item in items) {
        counters[item] = 0;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Stocks mis à jour !"),
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
          duration: Duration(seconds: 1),),
      );
    });
  }

  void _startAutoIncrement(String item) {
    holdTimer?.cancel();
    holdTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        counters[item] = (counters[item] ?? 0) + 1;
      });
    });
  }

  void _startAutoDecrement(String item) {
    holdTimer?.cancel();
    holdTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        if ((counters[item] ?? 0) > 0) {
          counters[item] = (counters[item] ?? 0) - 1;
        }
      });
    });
  }

  void _stopAutoIncrement() {
    holdTimer?.cancel();
    holdTimer = null;
  }

  void _stopAutoDecrement() {
    holdTimer?.cancel();
    holdTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des stocks")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                String item = items[index];
                int quantity = stock[item] ?? 0;
                int counter = counters[item] ?? 0;

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
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Stock: $quantity',
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => decrementCounter(item),
                        onLongPressStart: (_) {
                          if ((counters[item] ?? 0) > 0) {
                            _startAutoDecrement(item);
                          }
                        },
                        onLongPressEnd: (_) {
                          _stopAutoDecrement();
                        },
                        child: const Icon(Icons.remove),
                      ),
                      SizedBox(width: 16,),
                      Text('$counter', style: const TextStyle(fontSize: 18)),
                      SizedBox(width: 16,),
                      GestureDetector(
                        onTap: () => incrementCounter(item),
                        onLongPressStart: (_) {
                          _startAutoIncrement(item);
                        },
                        onLongPressEnd: (_) {
                          _stopAutoIncrement();
                        },
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: validateAllAdditions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  shadowColor: Colors.deepPurple.withOpacity(0.4),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("Valider les ajouts"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}