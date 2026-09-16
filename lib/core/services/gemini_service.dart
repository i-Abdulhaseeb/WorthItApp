import 'package:firebase_ai/firebase_ai.dart';

class GeminiService {
  late final GenerativeModel _generativeModel;
  GeminiService() {
    _generativeModel = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.6-flash',
    );
  }
}
