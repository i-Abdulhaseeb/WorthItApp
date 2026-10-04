import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worthitapp/app/theme/app_colors.dart';
import 'package:worthitapp/app/theme/app_text_styles.dart';

import '../controllers/purchase_controller.dart';

class StartPurchaseView extends GetView<PurchaseController> {
  const StartPurchaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verdict',
          style: AppTextStyles.textTheme.titleLarge?.copyWith(
            color: AppColors.primaryEmerald,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'What are you thinking about buying?',
                textAlign: TextAlign.center,
                style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Give us the basics. We'll ask the important questions next.",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLg.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              Obx(() {
                if (controller.selectedImage.value == null) {
                  return _OptionCard(
                    icon: Icons.camera_alt_outlined,
                    title: 'Upload a photo',
                    subtitle: 'Choose a photo from gallery',
                    onTap: controller.pickImage,
                  );
                }
                return Image.file(
                  File(controller.selectedImage.value!.path),
                  width: 200,
                  height: 200,
                );
              }),
              const SizedBox(height: 16),
              _OptionCard(
                icon: Icons.edit_outlined,
                title: 'Enter manually',
                subtitle: 'Type the product name and brand',
                onTap: controller.showNameDialog,
              ),
              const SizedBox(height: 16),
              _OptionCard(
                icon: Icons.link_outlined,
                title: 'Paste a link',
                subtitle: 'Paste a URL from any store',
                onTap: controller.showLinkDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: AppColors.onSurface),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: AppTextStyles.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
