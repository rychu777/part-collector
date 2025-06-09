import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/DetailedProduct.dart';

abstract class ProductRepository {
  Future<List<DetailedProduct>> getProducts();
}

class FirestoreProductRepository implements ProductRepository {
  @override
  Future<List<DetailedProduct>> getProducts() async {
    final snap = await FirebaseFirestore.instance.collection('components').get();
    return snap.docs.map((d) => DetailedProduct.fromJson(d.data())).toList();
  }
}