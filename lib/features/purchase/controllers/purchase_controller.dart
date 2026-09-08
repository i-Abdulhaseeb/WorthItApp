import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:worthitapp/app/routes/app_routes.dart';

/// Controller managing the purchase evaluation workflow
class PurchaseController extends GetxController {
  final ImagePicker picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final TextEditingController productName = TextEditingController();
  final TextEditingController productLink = TextEditingController();
  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = image;
      navigateToNextScreen();
    }
  }

  void showNameDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Add product name or brand',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),

        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),

        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),

            const SizedBox(height: 16),

            const Text(
              'Tell us the name of the product\nor the brand',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: productName,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. AirPods Pro',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),

        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),

        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),

          ElevatedButton(
            onPressed: () {
              final text = productName.text.trim();

              if (text.isNotEmpty) {
                Get.back(result: text);
                print(text);
                navigateToNextScreen();
              }
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void showLinkDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Add product Link',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),

        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),

        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),

            const SizedBox(height: 16),

            const Text(
              'Paste the link to the product',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: productLink,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. https//AirPodsPro.apple.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),

        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),

        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),

          ElevatedButton(
            onPressed: () {
              final text = productLink.text.trim();

              if (text.isNotEmpty) {
                Get.back(result: text);
                print(text);
                navigateToNextScreen();
              }
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
    navigateToNextScreen();
  }

  void navigateToNextScreen() {
    if (productLink.text != '' &&
        productName.text != '' &&
        selectedImage.value != null) {
      Get.toNamed(AppRoutes.productDetails);
    }
  }
}
