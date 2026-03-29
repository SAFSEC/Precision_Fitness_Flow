import 'package:flutter/material.dart' hide Badge;
import '../core/constants/app_colors.dart';
import '../core/services/badge_service.dart';

class BadgeItem extends StatelessWidget {
  final WorkoutBadge badge;

  const BadgeItem({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    Color tierColor;
    switch (badge.tier) {
      case BadgeTier.gold:
        tierColor = const Color(0xFFFFD700); // Gold
        break;
      case BadgeTier.silver:
        tierColor = const Color(0xFFC0C0C0); // Silver
        break;
      case BadgeTier.bronze:
        tierColor = const Color(0xFFCD7F32); // Bronze
        break;
    }

    return Tooltip(
      message: badge.description,
      triggerMode: TooltipTriggerMode.tap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    tierColor,
                    tierColor.withOpacity(0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: tierColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                badge.icon,
                color: kColorBackground,
                size: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              badge.tier.name.toUpperCase(),
              style: TextStyle(
                color: tierColor,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              badge.name,
              style: const TextStyle(
                color: kColorText,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
