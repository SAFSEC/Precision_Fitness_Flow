import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SafetyHintBanner extends StatelessWidget {
  final String safetyHint;

  const SafetyHintBanner({
    super.key,
    required this.safetyHint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: kColorSafetyHint.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: kColorSafetyHint.withOpacity(0.5),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: kColorSafetyHint,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gelenkschutz',
                  style: TextStyle(
                    color: kColorSafetyHint,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  safetyHint,
                  style: const TextStyle(
                    color: kColorText,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
