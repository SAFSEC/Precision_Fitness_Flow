import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/services/badge_service.dart';
import 'badge_item.dart';

class BadgesSection extends ConsumerWidget {
  const BadgesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlockedBadges = ref.watch(badgeServiceProvider);

    if (unlockedBadges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            'Erfolge & Abzeichen',
            style: TextStyle(
              color: kColorText,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: unlockedBadges.length,
            itemBuilder: (context, index) {
              return BadgeItem(badge: unlockedBadges[index]);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
