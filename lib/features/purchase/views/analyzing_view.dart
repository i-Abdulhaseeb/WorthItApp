import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/analysis_controller.dart';

/// Loading / AI evaluation in-progress view
class AnalyzingView extends GetView<AnalysisController> {
  const AnalyzingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Analyzing Purchase...'),
      ),
    );
  }
}
