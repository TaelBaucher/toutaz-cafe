import 'package:flutter/material.dart';
import 'package:toutaz_cafe/controllers/settingsController.dart';
import 'package:toutaz_cafe/ui/settings_widgets/add_product_form.dart';
import 'package:toutaz_cafe/ui/settings_widgets/retire_product_form.dart';
import 'package:toutaz_cafe/ui/settings_widgets/change_stock_form.dart';
import 'package:toutaz_cafe/ui/settings_widgets/change_price_form.dart';
import 'package:toutaz_cafe/ui/settings_widgets/change_name_form.dart';
import 'package:toutaz_cafe/ui/settings_widgets/change_password_form.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    _settingsController = SettingsController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AddProductForm(controller: _settingsController),
            const SizedBox(height: 10),
            RetireProductForm(controller: _settingsController),
            const SizedBox(height: 10),
            ChangeStockForm(controller: _settingsController),
            const SizedBox(height: 10),
            ChangePriceForm(controller: _settingsController),
            const SizedBox(height: 10),
            ChangeNameForm(controller: _settingsController),
            const SizedBox(height: 10),
            ChangePasswordForm(controller: _settingsController),
          ],
        ),
      ),
    );
  }
}
