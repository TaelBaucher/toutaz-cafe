import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:toutaz_cafe/Models/firestoreResult.dart';
import 'package:toutaz_cafe/services/settings_service.dart';

class SettingsController with WidgetsBindingObserver {
  final SettingsService _settingsService = SettingsService();

  SettingsController() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> verifyPassword(String input) async {
    final stored = await _settingsService.fetchPassword();
    if (stored == null) return false;

    final inputHash = _hashPassword(input);
    return stored == inputHash;
  }

  Future<FirestoreResult> changePassword(String currentPassword, String newPassword) async {
    bool check = await verifyPassword(currentPassword);

    if (!check) {
      return FirestoreResult(success: false, error: "Mot de passe incorrect");
    }

    try {
      final newPasswordHash = _hashPassword(newPassword);
      await _settingsService.updatePassword(newPasswordHash);
      return FirestoreResult(success: true);
    } catch(e) {
      return FirestoreResult(success: false, error: e.toString());
    }
  }

  Future<FirestoreResult> addProduct(String name, String type, double price) async {
    try {
      await _settingsService.addProduct(name, type, price);
      return FirestoreResult(success: true);
    } catch (e) {
      return FirestoreResult(success: false, error: e.toString());
    }
  }

  Future<FirestoreResult> retireProduct(String name) async {
    try {
      await _settingsService.retireProduct(name);
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
      await _settingsService.changeStock(name, quantity);
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
      await _settingsService.changePrice(name, price);
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
      await _settingsService.changeName(name, newName);
      return FirestoreResult(success: true);
    } catch (e) {
      return FirestoreResult(success: false, error: e.toString());
    }
  }
}