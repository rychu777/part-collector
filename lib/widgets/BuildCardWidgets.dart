// lib/widgets/BuildCardWidgets.dart

import 'package:flutter/material.dart';
import 'package:first_app/models/BuildFile.dart';
import 'package:first_app/legacy/constants.dart';

class NewBuildCard extends StatelessWidget {
  final VoidCallback onCreate;
  const NewBuildCard({Key? key, required this.onCreate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kMainBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: kPurple, width: 2),
      ),
      child: InkWell(
        key: const Key('add_build_button'),
        borderRadius: BorderRadius.circular(16),
        onTap: onCreate,
        child: const Center(
          child: Icon(Icons.add, size: 48, color: kPurple),
        ),
      ),
    );
  }
}

class ExistingBuildCard extends StatefulWidget {
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
  State<ExistingBuildCard> createState() => _ExistingBuildCardState();
}

class _ExistingBuildCardState extends State<ExistingBuildCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600), // czas przytrzymania
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onLongPress();
        _controller.reset(); // reset by można znów przytrzymać
      }
    });
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thumb = widget.buildFile.components.isNotEmpty &&
        widget.buildFile.components.first.imageUrls.isNotEmpty
        ? widget.buildFile.components.first.imageUrls.first
        : null;

    return Card(
      key: Key('build_card_${widget.buildFile.name}'),
      clipBehavior: Clip.antiAlias,
      color: kDarkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: kPurple, width: 2),
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: thumb != null
                  ? Image.network(
                thumb,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/img/placeholder.jpg',
                  fit: BoxFit.cover,
                ),
              )
                  : Image.asset(
                'assets/img/placeholder.jpg',
                fit: BoxFit.cover,
              ),
            ),

            // 1. Stała ciemna poświata (zawsze obecna)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.55),
              ),
            ),

            // 2. Narastająca rozjaśniająca warstwa podczas przytrzymania
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    color: Colors.white.withOpacity(0.3 * _controller.value),
                  );
                },
              ),
            ),

            // Tekst
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.buildFile.name,
                      style: const TextStyle(
                        color: kWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${widget.buildFile.components.length} elementów',
                      style: const TextStyle(
                        color: kWhite,
                        fontSize: 14,
                      ),
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
