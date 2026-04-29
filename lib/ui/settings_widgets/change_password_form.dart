import 'package:flutter/material.dart';
import 'package:toutaz_cafe/controllers/settingsController.dart';

class ChangePasswordForm extends StatefulWidget {
  final SettingsController controller;
  
  const ChangePasswordForm({super.key, required this.controller});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isExpanded = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final result = await widget.controller.changePassword(
        _passwordController.text,
        _newPasswordController.text
      );

      if (!mounted) return;

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mot de passe modifié avec succès !"), backgroundColor: Colors.green),
        );
        setState(() {
          _isExpanded = false;
          _passwordController.clear();
          _newPasswordController.clear();
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
                const Center(child: Text("Changer le mot de passe", style: TextStyle(fontSize: 16))),
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
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Mot de passe actuel", prefixIcon: const Icon(Icons.lock_open_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? "Requis" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Nouveau mot de passe", prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Requis";
                    if (val.length < 6) return "Min 6 chiffres";
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
