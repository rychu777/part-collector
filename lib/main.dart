import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'assistant_view.dart';
import 'detail_view.dart';
import 'part_view.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        '/assistant': (context) => const AssistantView(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<dynamic>>? _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadProducts();
  }

// Tu wczytujemy pliki z bazy
  Future<List<Map<String, dynamic>>> _loadProducts() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('components.json')
        .get();

    final components = querySnapshot.docs
        .map((doc) => doc.data())
        .toList();

    return components;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Menu')),
      body: FutureBuilder<List<dynamic>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Błąd wczytywania danych: ${snapshot.error}'));
          }
          final products = snapshot.data!.cast<Map<String, dynamic>>();
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PartView(allProducts: products),
                      ),
                    );
                  },
                  child: const Text('PartView'),
                ),
                const SizedBox(height: 16),
                if (products.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailView(productData: products.first),
                        ),
                      );
                    },
                    child: const Text('DetailView'),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/assistant');
                  },
                  child: const Text('AssistantView'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
