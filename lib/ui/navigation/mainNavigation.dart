import 'package:flutter/material.dart';
import 'package:toutaz_cafe/controllers/settingsController.dart';
import 'package:toutaz_cafe/ui/salesPage.dart';
import 'package:toutaz_cafe/ui/purchasePage.dart';
import 'package:toutaz_cafe/ui/settingsPage.dart';
import 'package:toutaz_cafe/ui/stockPage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;
  final _settingsController = SettingsController();

  final List<Widget> _pages = const [
    PurchasePage(),
    StockPage(),
    SalesPage(),
    SettingsPage()
  ];

  Future<void> _askPassword(int index) async {
    final controller = TextEditingController();
    bool granted = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Mot de passe requis"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: const InputDecoration(hintText: "Entrez le mot de passe"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              final ok = await _settingsController.verifyPassword(controller.text);
              if (ok) {
                granted = true;
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Mot de passe incorrect")),
                );
              }
            },
            child: const Text("Valider"),
          ),
        ],
      ),
    );

    if (granted) setState(() => _index = index);
  }

  void _onDestinationSelected(int index) {
    if (index == 3) {
      if (_index == 3) return;
      _askPassword(index);
    } else {
      setState(() => _index = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          NavigationDestination(icon: Icon(Icons.coffee), label: "Commandes"),
          NavigationDestination(icon: Icon(Icons.move_to_inbox), label: "Stocks"),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: "Bilan"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Paramètres"),
        ],
      ),
    );
  }
}