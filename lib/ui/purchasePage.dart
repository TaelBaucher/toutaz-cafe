import 'package:flutter/material.dart';
import 'package:toutaz_cafe/controllers/stockController.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  late final StockController _stockController;
  String? selectedItem;
  int selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    _stockController = StockController();
    _stockController.startListeningToStocks();

    _stockController.onStockUpdated = () {
      setState(() {});
    };
  }

  @override
  void dispose() {
    _stockController.dispose();
    super.dispose();
  }

  void _onItemTapped(String item, int quantity) {
    setState(() {
      selectedItem = selectedItem == item ? null : item;
      selectedQuantity = (quantity == 0) ? 0 : 1;
    });
  }

  void _addToOrder() async {
    final result = await _stockController.consumeItem(selectedItem!, selectedQuantity);

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
        content: Text('$selectedItem x$selectedQuantity ajouté !'),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        duration: const Duration(seconds: 1),
      ),
    );

    setState(() { selectedItem = null; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stock = _stockController.currentStocks.value;
    final items = stock.keys.toList();

    return Scaffold(
      appBar: AppBar(title: Text("Commandes")),
      body: Stack(
        children: [
          GridView.count(
            crossAxisCount: 3,
            padding: const EdgeInsets.all(8),
            children: items.map((item) {
              final isSelected = item == selectedItem;
              final quantity = stock[item] ?? 0;

              return GestureDetector(
                onTap: () => _onItemTapped(item, quantity),
                child: Card(
                  color: isSelected ? Colors.deepPurple.shade100 : null,
                  elevation: isSelected ? 6 : 2,
                  shape: RoundedRectangleBorder(
                    side: isSelected
                        ? BorderSide(color: Colors.deepPurple, width: 2)
                        : BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.deepPurple : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          if (selectedItem != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.deepPurple.shade100,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: selectedQuantity > 1
                                ? () => setState(() => selectedQuantity--)
                                : null,
                            icon: Icon(Icons.remove),
                          ),
                          Text('$selectedQuantity'),
                          IconButton(
                            onPressed: (stock[selectedItem] == -1 || selectedQuantity < stock[selectedItem]!)
                                ? () => setState(() => selectedQuantity++)
                                : null,
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
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
                        onPressed: (selectedQuantity > 0)
                            ? _addToOrder
                            : null,
                        child: Text("Valider"),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}