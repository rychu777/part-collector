import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'constants.dart';
import 'configuration_view.dart';

class ConfigurationList extends StatefulWidget {
  const ConfigurationList({Key? key}) : super(key: key);

  @override
  State<ConfigurationList> createState() => _ConfigurationListState();
}

class _ConfigurationListState extends State<ConfigurationList> {
  final List<_BuildFile> _builds = [];

  @override
  void initState() {
    super.initState();
    _loadAssetBuilds();
  }

  Future<void> _loadAssetBuilds() async {
    final manifest = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> map = json.decode(manifest);
    final keys = map.keys
        .where((k) => k.startsWith('assets/generated-builds/') && k.endsWith('.json'))
        .toList()
      ..sort();

    _builds.clear();
    for (var path in keys) {
      final content = await rootBundle.loadString(path);
      final List<dynamic> items = json.decode(content);
      final name = path.split('/').last.replaceAll('.json', '');
      _builds.add(
        _BuildFile(name: name, components: items.cast<Map<String, dynamic>>()),
      );
    }
    setState(() {});
  }

  Future<void> _createNewBuild() async {
    final name = await _askBuildName();
    if (name == null || name.isEmpty) return;
    final result = await Navigator.push<List<Map<String, dynamic>>>(
      context,
      MaterialPageRoute(
        builder: (_) => ConfigurationView(
          buildComponents: [],
          buildName: name,
          onSave: null,
        ),
      ),
    );
    if (result != null) {
      _builds.add(_BuildFile(name: name, components: result));
      setState(() {});
      // TODO: zapis do pliku
    }
  }

  Future<String?> _askBuildName() async {
    String input = '';
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kSurfaceLighter,
        title: const Text('Nazwa zestawu', style: TextStyle(color: kDarkGrey)),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Wpisz nazwę'),
          onChanged: (v) => input = v,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('Anuluj', style: TextStyle(color: kPurple)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, input.trim()),
            child: const Text('OK', style: TextStyle(color: kPurple)),
          ),
        ],
      ),
    );
  }

  void _openBuild(_BuildFile build) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfigurationView(
          buildComponents: build.components,
          buildName: build.name,
          onSave: (updated) async {
            build.components
              ..clear()
              ..addAll(updated);
            setState(() {});
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(int index) async {
    final name = _builds[index].name;
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kSurfaceLighter,
        title: Text('Usuń zestaw?', style: const TextStyle(color: kDarkGrey)),
        content: Text('Czy na pewno chcesz usunąć "$name"?',
            style: const TextStyle(color: kDarkGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Anuluj', style: TextStyle(color: kPurple)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Usuń', style: TextStyle(color: kRedError)),
          ),
        ],
      ),
    );
    if (res == true) {
      setState(() {
        _builds.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainBackground,
      appBar: AppBar(
        backgroundColor: kPrimaryDark,
        title: const Text('Zestawy', style: TextStyle(color: kWhite)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          itemCount: _builds.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (ctx, i) {
            if (i == _builds.length) {
              return Card(
                color: kDarkGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: kPurple, width: 2),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _createNewBuild,
                  child: const Center(
                    child: Icon(Icons.add, size: 48, color: kPurple),
                  ),
                ),
              );
            }
            return _buildCard(ctx, i, _builds[i]);
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext ctx, int index, _BuildFile b) {
    final first = b.components.isNotEmpty ? b.components.first : null;
    final thumb = first != null && (first['images'] as List).isNotEmpty
        ? first['images'][0] as String
        : null;

    return Card(
      color: kDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: kPurple, width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openBuild(b),
        onLongPress: () => _confirmDelete(index),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (thumb != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(thumb, height: 80, fit: BoxFit.cover),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      b.name,
                      style: const TextStyle(
                        color: kWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${b.components.length} elementów',
                      style: const TextStyle(color: kWhite),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildFile {
  final String name;
  final List<Map<String, dynamic>> components;

  _BuildFile({required this.name, required this.components});
}
