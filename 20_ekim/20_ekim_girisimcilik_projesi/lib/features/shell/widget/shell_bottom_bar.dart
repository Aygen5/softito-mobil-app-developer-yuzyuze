import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';

class ShellBottomBar extends StatelessWidget {
  final int seciliIndex;
  final ValueChanged<int> onTabSelected;

  const ShellBottomBar({
    super.key,
    required this.seciliIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? colors.nightBlue : colors.surfaceDark,
        border: Border(
          top: BorderSide(
            color: colors.border.withValues(alpha: isDark ? 0.6 : 0.8),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: seciliIndex,
        onDestinationSelected: onTabSelected,
        backgroundColor: Colors.transparent,
        indicatorColor: colors.rocketFlame.withValues(alpha: 0.18),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.psychology_alt_rounded),
            selectedIcon: Icon(
              Icons.psychology_alt_rounded,
              color: Color(0xFFFF6B2C),
            ),
            label: AppStrings.tabMentor,
          ),
          NavigationDestination(
            icon: Icon(Icons.rocket_launch_rounded),
            selectedIcon: Icon(
              Icons.rocket_launch_rounded,
              color: Color(0xFFFF6B2C),
            ),
            label: AppStrings.tabYatirimci,
          ),
          NavigationDestination(
            icon: Icon(Icons.workspace_premium_rounded),
            selectedIcon: Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFFFF6B2C),
            ),
            label: AppStrings.tabProgramlar,
          ),
          NavigationDestination(
            icon: Icon(Icons.hub_rounded),
            selectedIcon: Icon(Icons.hub_rounded, color: Color(0xFFFF6B2C)),
            label: AppStrings.tabTopluluk,
          ),
        ],
      ),
    );
  }
}
