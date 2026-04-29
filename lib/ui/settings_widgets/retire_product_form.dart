import 'package:flutter/material.dart';
import 'package:toutaz_cafe/controllers/settingsController.dart';

class RetireProductForm extends StatefulWidget {
  final SettingsController controller;
  
  const RetireProductForm({super.key, required this.controller});

  @override
  State<RetireProductForm> createState() => _RetireProductFormState();
}

class _RetireProductFormState extends State<RetireProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isExpanded = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final result = await widget.controller.retireProduct(_nameController.text);

      if (!mounted) return;

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produit retiré avec succès !"), backgroundColor: Colors.green),
        );
        setState(() {
          _isExpanded = false;
          _nameController.clear();
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
                const Center(child: Text("Retirer un produit", style: TextStyle(fontSize: 16))),
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
