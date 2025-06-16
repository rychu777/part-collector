// lib/main.dart

import 'package:first_app/repositories/ConfigurationRepository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:first_app/repositories/ProductRepository.dart';
import 'package:first_app/views/ConfigurationListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/component.dart';
import 'viewmodels/ProductCatalogViewModel.dart';

class FirestoreConfigurationRepository implements ConfigurationRepository {
  @override
  Future<List<Component>> fetchComponents(String category) async {
    final snap = await FirebaseFirestore.instance
        .collection('components')
        .where('category', isEqualTo: category)
        .get();
    return snap.docs
        .map((d) => Component.fromJson(d.data()))
        .toList();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductCatalogViewModel(FirestoreProductRepository()),
        ),
        // repozytorium dla części/produktów
        Provider<ProductRepository>(
          create: (_) => FirestoreProductRepository(),
        ),
        // repozytorium dla wyboru komponentów
        Provider<ConfigurationRepository>(
          create: (_) => FirestoreConfigurationRepository(),
        ),
      ],
      child: MaterialApp(
        title: 'First App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const ConfigurationListView(),
        // jeżeli chcesz nawigować nazwanymi trasami:
        routes: {
          // '/parts': (_) => PartViewMVVM(),
          // '/summary': (_) => SummaryViewMVVM(...),
          // '/detail': (_) => DetailViewMVVM(...),
        },
      ),
    );
  }
}