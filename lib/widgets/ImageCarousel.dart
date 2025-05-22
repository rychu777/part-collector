import 'package:flutter/material.dart';
import 'package:first_app/legact/constants.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const ImageCarousel({required this.images, required this.currentIndex, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Stack(
        children: [
          Container(color: kDarkGrey, height: 200, child: const Center(child: Text('Brak zdjęć', style: TextStyle(color: kWhite)))),
          _BackButton(),
        ],
      );
    }
    return Stack(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: onPageChanged,
            itemBuilder: (ctx, i) => Image.network(images[i], fit: BoxFit.cover),
          ),
        ),
        _BackButton(),
        Positioned(
          bottom: 8, left: 0, right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: currentIndex == i ? kPurple : kWhite,
                shape: BoxShape.circle,
              ),
            )),
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8, left: 8,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(4),
          child: const Icon(Icons.arrow_back, color: kWhite),
        ),
      ),
    );
  }
}
