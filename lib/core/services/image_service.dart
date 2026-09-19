import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> saveProductImage(XFile? image) async {
  if (image == null) return null;

  final directory = await getApplicationDocumentsDirectory();

  final extension = image.path.split('.').last;

  final fileName =
      'product_${DateTime.now().millisecondsSinceEpoch}.$extension';

  final savedImage = await File(image.path).copy('${directory.path}/$fileName');

  return savedImage.path;
}
