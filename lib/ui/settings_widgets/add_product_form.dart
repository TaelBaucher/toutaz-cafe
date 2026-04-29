import 'package:flutter/material.dart';
import 'package:toutaz_cafe/controllers/settingsController.dart';

class AddProductForm extends StatefulWidget {
  final SettingsController controller;
  
  const AddProductForm({super.key, required this.controller});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String? _typeController;
  bool _isExpanded = false;

  final List<String> types = [
    "Soda", "Diabolo", "Jus de fruits", "Smoothie", "Sirop",
    "Thé", "Café", "Chocolat", "Snack salé", "Snack sucré"
  ];

  void _submit() async {
    if (_formKey.currentState!.validate() && _typeController != null) {
      final result = await widget.controller.addProduct(
        _nameController.text,
        _typeController!,
        double.parse(_priceController.text),
      );

      if (!mounted) return;

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produit ajouté avec succès !"), backgroundColor: Colors.green),
        );
        setState(() {
          _isExpanded = false;
          _nameController.clear();
          _priceController.clear();
          _typeController = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: ${result.error}"), backgroundColor: Colors.red),
        );
      }
    } else if (_typeController == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner un type"), backgroundColor: Colors.orange),
      );
    }
  }

  void _showTypeSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.category_outlined),
                    const SizedBox(width: 12),
                    const Text("Sélectionner le type du produit"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: types.length,
                  itemBuilder: (context, index) {
                    final type = types[index];
                    final isSelected = type == _typeController;
                    return InkWell(
                      onTap: () {
                        setState(() => _typeController = type);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        color: isSelected ? Colors.blue[50] : Colors.transparent,
                        child: Row(
                          children: [
                            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, 
                                 color: isSelected ? Colors.deepPurple : Colors.grey),
                            const SizedBox(width: 16),
                            Text(type, style: TextStyle(fontSize: 16, color: isSelected ? Colors.deepPurple : Colors.black)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
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
                const Center(child: Text("Ajouter un produit", style: TextStyle(fontSize: 16))),
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
                    labelText: "Prix", prefixIcon: const Icon(Icons.euro_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? "Requis" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  onTap: _showTypeSelectionBottomSheet,
                  decoration: InputDecoration(
                    labelText: "Type de produit", 
                    hintText: _typeController ?? "Sélectionner",
                    prefixIcon: const Icon(Icons.category_outlined),
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
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
