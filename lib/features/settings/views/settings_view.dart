import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/settings_controller.dart';
import '../widgets/currency_popup.dart';
import '../widgets/income_popup.dart';
import '../widgets/name_popup.dart';
import '../widgets/settings_tile.dart';
import '../widgets/working_hours_popup.dart';

/// Settings and preferences view
class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8F5),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Verdict",
          style: GoogleFonts.playfairDisplay(
            color: const Color.fromARGB(255, 39, 116, 41),
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "Settings",
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1C1B1B),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),

            // Profile Section
            Text(
              "Profile",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color.fromARGB(255, 39, 116, 41),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFECECEC), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Obx(
                () => Column(
                  children: [
                    SettingsTile(
                      icon: Icons.person_outline_rounded,
                      title: "Name",
                      value: controller.userName.value,
                      onTap: () => NamePopup.show(context),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF0F0F0),
                    ),
                    SettingsTile(
                      icon: Icons.payments_outlined,
                      title: "Currency",
                      value: controller.currency.value,
                      onTap: () => CurrencyPopup.show(context),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF0F0F0),
                    ),
                    SettingsTile(
                      icon: Icons.account_balance_wallet_outlined,
                      title: "Income",
                      value: controller.income.value,
                      onTap: () => IncomePopup.show(context),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF0F0F0),
                    ),
                    SettingsTile(
                      icon: Icons.access_time_rounded,
                      title: "Working hours",
                      value: controller.workingHours.value,
                      onTap: () => WorkingHoursPopup.show(context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // About Section
            Text(
              "About",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color.fromARGB(255, 39, 116, 41),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFECECEC), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Obx(
                () => Column(
                  children: [
                    SettingsTile(
                      icon: Icons.lock_outline_rounded,
                      title: "Privacy Policy",
                      showChevron: true,
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF0F0F0),
                    ),
                    SettingsTile(
                      icon: Icons.description_outlined,
                      title: "Terms of Service",
                      showChevron: true,
                      onTap: () {},
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFF0F0F0),
                    ),
                    SettingsTile(
                      icon: Icons.info_outline_rounded,
                      title: "About Should I Buy It",
                      value: controller.appVersion.value,
                      showChevron: false,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
