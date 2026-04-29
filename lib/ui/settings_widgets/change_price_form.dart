import 'package:flutter/material.dart';
import 'package:toutaz_cafe/controllers/settingsController.dart';

class ChangePriceForm extends StatefulWidget {
  final SettingsController controller;
  
  const ChangePriceForm({super.key, required this.controller});

  @override
  State<ChangePriceForm> createState() => _ChangePriceFormState();
}

class _ChangePriceFormState extends State<ChangePriceForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isExpanded = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final result = await widget.controller.changePrice(
        _nameController.text,
        double.parse(_priceController.text)
      );

      if (!mounted) return;

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Prix modifié avec succès !"), backgroundColor: Colors.green),
        );
        setState(() {
          _isExpanded = false;
          _nameController.clear();
          _priceController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: ${result.error}"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(_isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right),
                ),
                const Center(child: Text("Changer le prix d'un produit", style: TextStyle(fontSize: 16))),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Nom du produit", prefixIcon: const Icon(Icons.coffee_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (val) => (val == null || val.isEmpty) ? "Requis" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Nouveau prix", prefixIcon: const Icon(Icons.euro_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Requis";
                    if (double.tryParse(val) == null) return "Nombre valide requis";
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Valider", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
        ]
      ],
    );
  }
}
