import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/question_controller.dart';

/// Question answering flow view
class QuestionsView extends GetView<QuestionController> {
  const QuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Questions View'),
      ),
    );
  }
}
