import 'package:flutter/material.dart';
import 'package:first_app/legact/constants.dart';

class StyledImageCarousel extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onBackPressed;

  const StyledImageCarousel({
    Key? key,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Stack(
        children: [
          Container(
            color: kDarkGrey,
            height: 200,
            child: const Center(
              child: Text(
                'Brak zdjęć',
                style: TextStyle(color: kWhite),
              ),
            ),
          ),
          _buildBackButton(context),
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
            itemBuilder: (context, index) {
              final imageUrl = images[index];
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: kSurfaceLighter.withOpacity(0.2),
                  child: Center(child: Icon(Icons.broken_image, color: kWhite.withOpacity(0.7), size: 50)),
                ),
              );
            },
          ),
        ),
        _buildBackButton(context),
        Positioned(
          bottom: 8,
          right: 0,
          left: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentIndex == index ? kPurple : kWhite,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      child: GestureDetector(
        onTap: onBackPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(4),
          child: const Icon(
            Icons.arrow_back,
            color: kWhite,
          ),
        ),
      ),
    );
  }
}