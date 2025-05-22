import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:first_app/models/BuildFile.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/viewmodels/ConfigurationListViewModel.dart';
import 'package:first_app/views/ConfigurationView.dart';
import 'package:first_app/legact/constants.dart';

class ConfigurationListView extends StatelessWidget {
  const ConfigurationListView({Key? key}) : super(key: key);

  Future<String?> _askBuildName(BuildContext context) async {
    String input = '';
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kSurfaceLighter,
        title: const Text('Nazwa zestawu', style: TextStyle(color: kDarkGrey)),
        content: TextField(autofocus: true, decoration: const InputDecoration(hintText: 'Wpisz nazwę'), onChanged: (v) => input = v),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Anuluj', style: TextStyle(color: kPurple))),
          TextButton(onPressed: () => Navigator.pop(ctx, input.trim()), child: const Text('OK', style: TextStyle(color: kPurple))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConfigurationListViewModel>(
      create: (_) => ConfigurationListViewModel()..loadBuilds(),
      child: Consumer<ConfigurationListViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
          if (vm.error != null) return Scaffold(body: Center(child: Text('Błąd: \${vm.error}')));

          return Scaffold(
            backgroundColor: kMainBackground,
            appBar: AppBar(backgroundColor: kPrimaryDark, title: const Text('Zestawy', style: TextStyle(color: kWhite))),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                itemCount: vm.builds.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 3/2),
                itemBuilder: (ctx, i) {
                  if (i == vm.builds.length) return _buildNewCard(context, vm);
                  return _buildExistingCard(context, vm, i);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewCard(BuildContext context, ConfigurationListViewModel vm) {
    return Card(
      color: kDarkGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: kPurple, width: 2)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final name = await _askBuildName(context);
          if (name == null || name.isEmpty) return;
          final result = await Navigator.push<List<Component>>(
            context,
            MaterialPageRoute(builder: (_) => ConfigurationView(buildName: name)),
          );
          if (result != null) vm.addBuild(BuildFile(name: name, components: result));
        },
        child: const Center(child: Icon(Icons.add, size: 48, color: kPurple)),
      ),
    );
  }

  Widget _buildExistingCard(BuildContext context, ConfigurationListViewModel vm, int index) {
    final b = vm.builds[index];
    final thumb = b.components.isNotEmpty && b.components.first.imageUrls.isNotEmpty ? b.components.first.imageUrls.first : null;
    return Card(
      color: kDarkGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: kPurple, width: 2)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final updated = await Navigator.push<List<Component>>(
            context,
            MaterialPageRoute(builder: (_) => ConfigurationView(buildName: b.name)),
          );
          if (updated != null) vm.updateBuild(index, updated);
        },
        onLongPress: () async {
          final res = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: kSurfaceLighter,
              title: const Text('Usuń zestaw?', style: TextStyle(color: kDarkGrey)),
              content: Text('Czy na pewno chcesz usunąć "\${b.name}"?', style: const TextStyle(color: kDarkGrey)),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Anuluj', style: TextStyle(color: kPurple))),
                TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Usuń', style: TextStyle(color: kRedError))),
              ],
            ),
          );
          if (res == true) vm.deleteBuild(index);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (thumb != null) ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(thumb, height: 80, fit: BoxFit.cover)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text(b.name, style: const TextStyle(color: kWhite, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('\${b.components.length} elementów', style: const TextStyle(color: kWhite)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
