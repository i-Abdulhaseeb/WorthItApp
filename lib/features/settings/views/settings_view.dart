import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/settings_controller.dart';
import '../widgets/currency_popup.dart';
import '../widgets/income_popup.dart';
import '../widgets/name_popup.dart';
import '../widgets/settings_tile.dart';
import '../widgets/working_hours_popup.dart';

/// Profile and preferences, using the same palette as the purchase flow.
class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'WorthIt.',
          style: GoogleFonts.playfairDisplay(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 26,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Settings', style: AppTextStyles.display),
                    const SizedBox(height: 6),
                    Text(
                      'Your profile. Your preferences.',
                      style: AppTextStyles.bodySm,
                    ),
                    const SizedBox(height: 28),
                    const _SectionTitle('Profile'),
                    Obx(
                      () => _ProfileCard(
                        name: controller.userName.value,
                        onTap: () => NamePopup.show(context),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const _SectionTitle('Preferences'),
                    Obx(
                      () => _SettingsGroup(
                        children: [
                          SettingsTile(
                            icon: Icons.payments_outlined,
                            title: 'Currency',
                            value: controller.currency.value,
                            onTap: () => CurrencyPopup.show(context),
                          ),
                          SettingsTile(
                            icon: Icons.account_balance_wallet_outlined,
                            title: 'Income',
                            value: controller.income.value,
                            onTap: () => IncomePopup.show(context),
                          ),
                          SettingsTile(
                            icon: Icons.schedule_rounded,
                            title: 'Working hours',
                            value: controller.workingHours.value,
                            onTap: () => WorkingHoursPopup.show(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    const _SectionTitle('About'),
                    _SettingsGroup(
                      children: [
                        const SettingsTile(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          subtitle: 'Not available yet',
                          showChevron: false,
                        ),
                        const SettingsTile(
                          icon: Icons.description_outlined,
                          title: 'Terms of Service',
                          subtitle: 'Not available yet',
                          showChevron: false,
                        ),
                        Obx(
                          () => SettingsTile(
                            icon: Icons.info_outline_rounded,
                            title: 'About WorthIt',
                            value: controller.appVersion.value,
                            onTap: () => _showAbout(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'A little thought before every purchase.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySm.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'WorthIt',
      applicationVersion: controller.appVersion.value,
      applicationIcon: const Icon(
        Icons.account_balance_wallet_outlined,
        color: AppColors.primary,
        size: 36,
      ),
      children: [
        Text(
          'Think through your next purchase with a clear Buy, Wait, '
          "or Don't Buy verdict.",
          style: AppTextStyles.bodySm,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.labelBold.copyWith(
          color: AppColors.onSurfaceVariant,
          fontSize: 13,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final displayName = name.trim();
    final initial = displayName.isEmpty
        ? 'W'
        : displayName.characters.first.toUpperCase();

    return Material(
      color: AppColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      initial,
                      style: AppTextStyles.headline.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name', style: AppTextStyles.bodySm),
                    const SizedBox(height: 2),
                    Text(
                      displayName.isEmpty ? 'Your name' : displayName,
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to edit',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0)
              const Divider(
                height: 1,
                thickness: 1,
                indent: 72,
                endIndent: 16,
                color: AppColors.surfaceContainer,
              ),
            children[index],
          ],
        ],
      ),
    );
  }
}
