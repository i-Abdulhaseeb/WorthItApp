import 'package:get/get.dart';

/// Gemini AI Service for decision evaluation
class GeminiService extends GetxService {
  Future<String> evaluatePurchase({
    required String productName,
    required double price,
    required Map<String, dynamic> answers,
  }) async {
    return 'Decision analysis result';
  }
}
