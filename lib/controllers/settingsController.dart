import 'package:flutter/cupertino.dart';
import 'package:toutaz_cafe/Models/firestoreResult.dart';
import 'package:toutaz_cafe/services/service.dart';

class SettingsController with WidgetsBindingObserver {
  final Service _service = Service();

  SettingsController() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<bool> verifyPassword(String input) async {
    final stored = await _service.fetchPassword();
    return stored != null && stored == input;
  }

  Future<FirestoreResult> changePassword(String currentPassword, String newPassword) async {
    bool check = await verifyPassword(currentPassword);

    if (!check) {
      return FirestoreResult(success: false, error: "Mot de passe incorect");
    }

    try {
      await _service.updatePassword(newPassword);
      return FirestoreResult(success: true);
    } catch(e) {
      return FirestoreResult(success: false, error: e.toString());
    }
  }

  Future<FirestoreResult> addProduct(String name, String type, double price) async {
    try {
      await _service.addProduct(name, type, price);
      return FirestoreResult(success: true);
    } catch (e) {
      return FirestoreResult(success: false, error: e.toString());
    }
  }

  Future<FirestoreResult> retireProduct(String name) async {
    try {
      await _service.retireProduct(name);
      return FirestoreResult(success: true);
    } catch (e) {
      return FirestoreResult(success: false, error: e.toString());
    }
  }

  Future<FirestoreResult> changeStock(String name, int quantity) async {
    if (quantity < 1) {
      return FirestoreResult(success: false, error: "Quantité inférieure à 1");
    }

    try {
      await _service.changeStock(name, quantity);
      return FirestoreResult(success: true);
    } catch (e) {
      return FirestoreResult(success: false, error: e.toString());
    }
  }

  Future<FirestoreResult> changePrice(String name, double price) async {
    if (price <= 0) {
      return FirestoreResult(success: false, error: "Prix inférieur ou égal à 0");
    }

    try {
      await _service.changePrice(name, price);
      return FirestoreResult(success: true);
    } catch (e) {
      return FirestoreResult(success: false, error: e.toString());
    }
  }

  Future<FirestoreResult> changeName(String name, String newName) async {
    if (newName.isEmpty) {
      return FirestoreResult(success: false, error: "Nouveau nom vide");
    }

    try {
      await _service.changeName(name, newName);
      return FirestoreResult(success: true);
    } catch (e) {
      return FirestoreResult(success: false, error: e.toString());
    }
  }
}