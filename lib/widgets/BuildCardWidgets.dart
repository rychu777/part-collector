// lib/widgets/BuildCardWidgets.dart

import 'package:flutter/material.dart';
import 'package:first_app/models/BuildFile.dart';
import 'package:first_app/legact/constants.dart';

class NewBuildCard extends StatelessWidget {
  final VoidCallback onCreate;
  const NewBuildCard({Key? key, required this.onCreate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: kPurple, width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onCreate,
        child: const Center(
          child: Icon(Icons.add, size: 48, color: kPurple),
        ),
      ),
    );
  }
}

class ExistingBuildCard extends StatelessWidget {
  final BuildFile buildFile;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ExistingBuildCard({
    Key? key,
    required this.buildFile,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thumb = buildFile.components.isNotEmpty &&
        buildFile.components.first.imageUrls.isNotEmpty
        ? buildFile.components.first.imageUrls.first
        : null;

    return Card(
      color: kDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: kPurple, width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (thumb != null)
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  thumb,
                  height: 80,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      buildFile.name,
                      style: const TextStyle(
                          color: kWhite, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${buildFile.components.length} elementów',
                      style: const TextStyle(color: kWhite),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
