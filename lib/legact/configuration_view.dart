
import 'package:flutter/material.dart';
import 'part_view.dart';
import 'constants.dart';
import 'summary_view.dart';

class ConfigurationView extends StatefulWidget {
  final String buildName;
  final List<Map<String, dynamic>> buildComponents;
  final Future<void> Function(List<Map<String, dynamic>> updated)? onSave;

  const ConfigurationView({
    Key? key,
    required this.buildName,
    required this.buildComponents,
    this.onSave,
  }) : super(key: key);

  @override
  _ConfigurationViewState createState() => _ConfigurationViewState();
}

class _ConfigurationViewState extends State<ConfigurationView> {
  static const Map<String, String> slots = {
    'CPU': 'Procesor',
    'GPU': 'Karta graficzna',
    'Motherboard': 'Płyta główna',
    'PSU': 'Zasilacz',
    'Disks': 'Pamięć masowa',
    'Cooling': 'Chłodzenie',
    'RAM': 'Pamięć RAM',
    'Case': 'Obudowa',
  };

  static const Map<String, String> slotImages = {
    'CPU': 'cpu.jpg',
    'GPU': 'gpu.jpg',
    'Motherboard': 'motherboard.jpg',
    'PSU': 'psu.png',
    'Disks': 'disc.jpg',
    'Cooling': 'cooling.jpg',
    'RAM': 'ram.jpg',
    'Case': 'case.jpg',
  };

  late Map<String, Map<String, dynamic>?> selected;
  late Map<String, bool> isSlotIncompatible;

  @override
  void initState() {
    super.initState();
    selected = { for (var key in slots.keys) key: null };
    isSlotIncompatible = { for (var key in slots.keys) key: false };

    for (var comp in widget.buildComponents) {
      final cat = comp['category'] as String?;
      if (cat != null && selected.containsKey(cat)) {
        selected[cat] = comp;
      }
    }
    _checkCompatibility();
  }

  Future<void> _selectSlot(String slotKey) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => PartView(initialCategory: slotKey)),
    );
    if (result != null && result['category'] == slotKey) {
      setState(() {
        selected[slotKey] = result;
        _checkCompatibility();
      });
    }
  }

  void _checkCompatibility() {
    setState(() {
      isSlotIncompatible = { for (var key in slots.keys) key: false };
    });

    final cpu = selected['CPU'];
    final motherboard = selected['Motherboard'];

    if (cpu != null && motherboard != null) {
      setState(() {
        isSlotIncompatible['CPU'] = true;
        isSlotIncompatible['Motherboard'] = true;
      });
    }
  }

  Future<void> _directSave() async {
    if (isSlotIncompatible.values.any((isIncompatible) => isIncompatible)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Niekompatybilne części'),
          content: const Text('W konfiguracji znajdują się niekompatybilne części. Czy na pewno chcesz zapisać?'),
          actions: [
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            TextButton(
              child: const Text('Zapisz mimo to'),
              onPressed: () {
                Navigator.of(ctx).pop();
                _performSave();
              },
            ),
          ],
        ),
      );
    } else {
      _performSave();
    }
  }

  void _performSave() async {
    final filled = selected.values.where((c) => c != null).cast<Map<String, dynamic>>().toList();
    if (widget.onSave != null) {
      await widget.onSave!(filled);
      if (mounted) Navigator.pop(context);
    } else {
      if (mounted) Navigator.pop(context, filled);
    }
  }


  void _navigateToSummary() {
    final List<Map<String, dynamic>> currentBuild = selected.values
        .where((c) => c != null)
        .cast<Map<String, dynamic>>()
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SummaryView(
          buildName: widget.buildName,
          buildComponents: currentBuild,
          onSaveConfiguration: widget.onSave,
          isSlotIncompatible: isSlotIncompatible,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainBackground,
      appBar: AppBar(
        backgroundColor: kPrimaryDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.buildName, style: const TextStyle(color: kWhite)),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: kWhite),
            onPressed: _directSave,
            tooltip: 'Zapisz konfigurację',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        children: slots.entries.map((entry) {
          final key = entry.key;
          final label = entry.value;
          final comp = selected[key];
          final assetName = slotImages[key]!;
          final bool isIncompatible = isSlotIncompatible[key] ?? false;

          IconData statusIcon;
          Color iconColor;

          if (isIncompatible) {
            statusIcon = Icons.cancel;
            iconColor = kRedError;
          } else if (comp != null) {
            statusIcon = Icons.check_circle;
            iconColor = Colors.greenAccent[700]!;
          } else {
            statusIcon = Icons.remove_circle_outline;
            iconColor = Colors.grey[600]!;
          }

          return Container(
            height: 80,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: kDarkGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isIncompatible ? kRedError.withOpacity(0.7) : kSurfaceLighter.withOpacity(0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(11),
              onTap: () => _selectSlot(key),
              splashColor: kPurple.withOpacity(0.3),
              highlightColor: kPurple.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/img/$assetName',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                              color: kSurfaceLighter.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Icon(Icons.broken_image_outlined, color: kWhite.withOpacity(0.7), size: 30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              color: isIncompatible ? kRedError : kWhite,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (comp != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              comp['name'] as String? ?? 'Brak nazwy',
                              style: TextStyle(
                                  color: isIncompatible ? kRedError.withOpacity(0.8) : kLightPurple, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ] else ...[
                            const SizedBox(height: 4),
                            Text(
                              'Nie wybrano',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 13, fontStyle: FontStyle.italic),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(statusIcon, color: iconColor, size: 28),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10).copyWith(bottom: MediaQuery.of(context).padding.bottom + 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkGrey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: kRedError, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Powrót', style: TextStyle(color: kRedError, fontSize: 16)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kRedError,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _navigateToSummary,
                child: const Text('Podsumowanie', style: TextStyle(color: kWhite, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}