import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> fetchPassword() async {
    final doc = await _firestore.collection('config').doc('settings').get();
    return doc.data()?['password'];
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _firestore.collection('config').doc('settings').update({
        'password': newPassword,
      });
    } catch (e) {
      throw Exception("Impossible de mettre à jour le mot de passe");
    }
  }
  Future<void> addProduct(String name, String type, double price) async {
    try {
      await _firestore
          .collection("stocks")
          .doc(name)
          .set({"name": name, "type": type, "price": price, "quantity": 0});
    } catch (e) {
      throw Exception("Impossible d'ajouter le produit suivant: $name");
    }
  }

  Future<void> retireProduct(String name) async {
    try {
      await _firestore.collection("stocks").doc(name).delete();
    } catch (e) {
      throw Exception("Impossible de supprimer le produit suivant: $name");
    }
  }

  Future<void> changeStock(String name, int quantity) async {
    try {
      await _firestore
          .collection("stocks")
          .doc(name)
          .update({"quantity": quantity});
    } catch (e) {
      throw Exception(
          "Impossible de changer le stock du produit suivant: $name");
    }
  }

  Future<void> changePrice(String name, double price) async {
    try {
      await _firestore.collection("stocks").doc(name).update({"price": price});
    } catch (e) {
      throw Exception(
          "Impossible de changer le stock du produit suivant: $name");
    }
  }

  Future<void> changeName(String name, String newName) async {
    try {
      final oldDoc = await _firestore.collection("stocks").doc(name).get();

      if (!oldDoc.exists) {
        throw Exception(
            "Impossible de changer le nom du produit suivant: $name");
      }

      await _firestore.collection("stocks").doc(newName).set(oldDoc.data()!);
      await _firestore.collection("stocks").doc(name).delete();
    } catch (e) {
      throw Exception("Impossible de changer le nom du produit suivant: $name");
    }
  }
}
