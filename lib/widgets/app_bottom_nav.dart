import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_text_styles.dart';

enum AppTab { week, subjects, summary, settings }

/// Bottom nav + center FAB per Main.dc.html. Tabs without a screen yet
/// (subjects/summary/settings land in later milestones) are visually present
/// but inert until their screens exist.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    required this.onFabPressed,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onTabSelected;
  final VoidCallback onFabPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: AppIcons.calendarWeek,
                label: 'Week',
                selected: currentTab == AppTab.week,
                onTap: () => onTabSelected(AppTab.week),
              ),
              _NavItem(
                icon: AppIcons.subjectsBook,
                label: 'Subjects',
                selected: currentTab == AppTab.subjects,
                onTap: () => onTabSelected(AppTab.subjects),
              ),
              const SizedBox(width: 60),
              _NavItem(
                icon: AppIcons.summaryChart,
                label: 'Summary',
                selected: currentTab == AppTab.summary,
                onTap: () => onTabSelected(AppTab.summary),
              ),
              _NavItem(
                icon: AppIcons.settingsGear,
                label: 'Settings',
                selected: currentTab == AppTab.settings,
                onTap: () => onTabSelected(AppTab.settings),
              ),
            ],
          ),
          Positioned(
            top: -22,
            child: GestureDetector(
              onTap: onFabPressed,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: AppIcons.path(
                  AppIcons.plus,
                  color: AppColors.surface,
                  size: 24,
                  strokeWidth: 2.25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accent : AppColors.textTertiary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcons.path(
              icon,
              color: color,
              size: 22,
              strokeWidth: selected ? 2 : 1.75,
              includeCircle: false,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.metadata.copyWith(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
