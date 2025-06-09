import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PrebuildRepository {
  Future<String> fetchPrebuildJsonByFileName(String fileName);
}

class FirebasePrebuildRepository implements PrebuildRepository {
  final FirebaseFirestore _firestore;

  FirebasePrebuildRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<String> fetchPrebuildJsonByFileName(String fileName) async {
    final doc = await _firestore.collection('configurations').doc(fileName).get();

    if (!doc.exists) {
      throw Exception("Konfiguracja '$fileName' nie znaleziona.");
    }

    final data = doc.data();
    final List<dynamic> componentsData = data?['components'] ?? [];

    // Zamiana listy map na JSON string
    final jsonString = jsonEncode(componentsData);

    return jsonString;
  }
}
