import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// Controller managing the purchase evaluation workflow
class PurchaseController extends GetxController {
  final ImagePicker picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = image;
    }
  }
}
