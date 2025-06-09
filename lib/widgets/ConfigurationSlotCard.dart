import 'package:flutter/material.dart';
import 'package:first_app/models/component.dart';
import 'package:first_app/legacy/constants.dart';

class ConfigurationSlotCard extends StatelessWidget {
  final String slotKey;
  final String label;
  final Component? component;
  final String image;
  final bool isIncompatible;
  final VoidCallback onTap;

  const ConfigurationSlotCard({
    Key? key,
    required this.slotKey,
    required this.label,
    required this.component,
    required this.image,
    required this.isIncompatible,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconType;
    Color iconColor;
    if (isIncompatible) {
      iconType = Icons.cancel;
      iconColor = kRedError;
    } else if (component != null) {
      iconType = Icons.check_circle;
      iconColor = Colors.greenAccent[700]!;
    } else {
      iconType = Icons.remove_circle_outline;
      iconColor = Colors.grey[600]!;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/img/$image',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: kSurfaceLighter.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.broken_image_outlined, color: kWhite.withOpacity(0.7), size: 30),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: isIncompatible ? kRedError : kWhite,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      component?.name ?? 'Nie wybrano',
                      style: TextStyle(
                        color: isIncompatible ? kRedError.withOpacity(0.8) : (component != null ? kLightPurple : Colors.grey[500]),
                        fontSize: 13,
                        fontStyle: component == null ? FontStyle.italic : FontStyle.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Icon(iconType, color: iconColor, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}