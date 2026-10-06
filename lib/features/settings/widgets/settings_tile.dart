import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

/// A setting with a wrapping value and an optional, real action.
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final String? subtitle;
  final bool showChevron;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.subtitle,
    this.showChevron = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isInteractive = onTap != null;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isInteractive
                    ? AppColors.primary.withValues(alpha: 0.06)
                    : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 21,
                color: isInteractive
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySm.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface,
                    ),
                  ),
                  if (value != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      value!,
                      style: AppTextStyles.bodyLg.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodySm.copyWith(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron && isInteractive) ...[
              const SizedBox(width: 12),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.outline,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
