import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/models/BuildFile.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/viewmodels/ConfigurationListViewModel.dart';
import 'package:first_app/views/ConfigurationView.dart';
import 'package:first_app/views/AssistantView.dart';
import 'package:first_app/widgets/BuildCardWidgets.dart';
import 'package:first_app/legacy/constants.dart';

class ConfigurationListView extends StatelessWidget {
  const ConfigurationListView({Key? key}) : super(key: key);

  Future<String?> _askBuildName(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConfigurationListViewModel>(
      create: (_) => ConfigurationListViewModel()..loadBuilds(),
      child: Consumer<ConfigurationListViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (vm.error != null) {
            return Scaffold(
              body: Center(child: Text('Błąd: ${vm.error}')),
            );
          }

          return Scaffold(
            backgroundColor: kMainBackground,
            appBar: AppBar(
              backgroundColor: kPrimaryDark,
              title: const Text('Zestawy', style: TextStyle(color: kWhite)),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.support_agent, color: kWhite),
                  tooltip: 'Asystent konfiguracji',
                  onPressed: () async {
                    final String? assistantJson = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(builder: (_) => const AssistantView()),
                    );
                    if (assistantJson == null) return;

                    try {
                      final decoded = jsonDecode(assistantJson);
                      if (decoded is List) {

                        for (var item in decoded) {
                          if (item is Map<String, dynamic> && item.containsKey('category')) {
                            item['category'] = (item['category'] as String).toUpperCase();
                          }
                        }

                        final comps = decoded
                            .map<Component>((e) => Component.fromJson(e as Map<String, dynamic>))
                            .toList();

                        final name = await _askBuildName(context);
                        if (name == null || name.isEmpty) return;

                        final newBuild = BuildFile(name: name, components: comps);
                        await vm.addBuild(newBuild);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Zapisano zestaw z Asystenta!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nieprawidłowy format danych z Asystenta.'),
                            backgroundColor: kRedError,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Błąd parsowania danych: $e'),
                          backgroundColor: kRedError,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                itemCount: vm.builds.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (ctx, i) {
                  if (i == vm.builds.length) {
                    return NewBuildCard(
                      onCreate: () async {
                        final name = await _askBuildName(context);
                        if (name == null || name.isEmpty) return;
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConfigurationView(
                              buildName: name,
                              onSaveConfiguration: (List<Component> selectedComponents) async {
                                final newBuild = BuildFile(name: name, components: selectedComponents);
                                await vm.addBuild(newBuild);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return ExistingBuildCard(
                    buildFile: vm.builds[i],
                    onTap: () async {
                      final b = vm.builds[i];
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ConfigurationView(
                            buildName: b.name,
                            initialComponents: b.components,
                            onSaveConfiguration: (List<Component> selectedComponents) async {
                              await vm.updateBuild(i, selectedComponents);
                            },
                          ),
                        ),
                      );
                    },
                    onLongPress: () async {
                      final b = vm.builds[i];
                      final res = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: kSurfaceLighter,
                          title: const Text('Usuń zestaw', style: TextStyle(color: kDarkGrey)),
                          content: Text('Czy na pewno usunąć "${b.name}"?',
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
                        await vm.deleteBuild(i);
                      }
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}