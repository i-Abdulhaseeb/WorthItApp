import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:worthitapp/features/purchase/controllers/purchase_controller.dart';

import '../controllers/question_controller.dart';
import '../widgets/question_option_card.dart';
import '../../../data/models/question_model.dart';

class QuestionsView extends GetView<QuestionController> {
  const QuestionsView({super.key});

  static const _green = Color(0xFF0E6E4E);
  static const _bg = Color(0xFFFBF4EE);
  static const _border = Color(0xFFE5E0D8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Obx(() {
          final question = controller.currentQuestion;
          return Column(
            children: [
              _buildHeader(question),
              _buildConsideringChip(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: _buildQuestionBody(question),
                ),
              ),
              _buildBottomBar(question),
            ],
          );
        }),
      ),
    );
  }

  // ---- Header -------------------------------------------------------

  Widget _buildHeader(Question question) {
    final progress =
        (controller.currentStep.value + 1) / controller.steps.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: controller.previousStep,
              ),
              Expanded(
                child: Text(
                  question.isOptional
                      ? 'OPTIONAL STEP'
                      : 'STEP ${question.step} OF ${question.totalSteps}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: _border,
              valueColor: const AlwaysStoppedAnimation(_green),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsideringChip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1EEE8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.headphones, size: 18, color: Colors.black54),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                  children: [
                    const TextSpan(text: 'Considering: '),
                    TextSpan(
                      text: controller.purchaseController.productName.value,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'Rs. ${controller.purchaseController.productPrice.value}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Body -----------------------------------------------------------

  Widget _buildQuestionBody(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question.category != null) ...[
          Text(
            question.category!.toUpperCase(),
            style: const TextStyle(
              color: _green,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          question.title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        if (question.subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            question.subtitle!,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
        const SizedBox(height: 20),
        if (question.computedBanner != null) _buildComputedBanner(question),
        if (question.type == QuestionType.singleSelect)
          _buildOptions(question)
        else
          _buildFreeText(question),
        const SizedBox(height: 12),
        _buildInfoBox(question),
        if (question.footerNote != null) ...[
          const SizedBox(height: 12),
          Text(
            question.footerNote!,
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ],
    );
  }

  // NOTE: this is a UI-only placeholder calculation — swap it for your
  // real cost-per-hour logic once the finance data is wired up.
  Widget _buildComputedBanner(Question question) {
    final price = controller.purchaseController.productPrice;
    final hourlyRate =
        controller.monthlyIncome / (controller.workHoursPerWeek * 4);
    final hours = hourlyRate == 0
        ? 0
        : (int.parse(controller.purchaseController.productPrice.value) /
                  hourlyRate)
              .round();

    final title = question.computedBanner!.titleTemplate
        .replaceAll(
          '{price}',
          'Rs. ${controller.purchaseController.productPrice}',
        )
        .replaceAll('{hours}', '$hours');
    final subtitle = question.computedBanner!.subtitleTemplate
        .replaceAll(
          '{income}',
          'Rs. ${controller.monthlyIncome.toStringAsFixed(0)}',
        )
        .replaceAll('{workHoursPerWeek}', '${controller.workHoursPerWeek}');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.schedule, color: _green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(Question question) {
    return Column(
      children: question.options.map((option) {
        final isSelected =
            controller.selectedOptionByQuestion[question.id] == option.id;
        return QuestionOptionCard(
          title: option.title,
          subtitle: option.subtitle,
          icon: _iconFor(option.icon),
          trailingLabel: option.trailingLabel,
          isSelected: isSelected,
          onTap: () => controller.selectOption(question.id, option.id),
          expandedChild: option.hasFollowUpFields
              ? _buildFollowUpFields(question.id, option)
              : null,
        );
      }).toList(),
    );
  }

  Widget _buildFollowUpFields(String questionId, QuestionOption option) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: option.followUpFields.map((field) {
        // Show a "saves Rs. X (Y%)" hint for the price field, like Q4.
        Widget? savingsLabel;
        if (field.id == 'alternative_price') {
          final entered = double.tryParse(
            controller.followUpValue(questionId, field.id).replaceAll(',', ''),
          );
          if (entered != null &&
              entered > 0 &&
              entered <
                  int.parse(controller.purchaseController.productPrice.value)) {
            final savings =
                int.parse(controller.purchaseController.productPrice.value) -
                entered;
            final percent =
                (savings /
                        int.parse(
                          controller.purchaseController.productPrice.value,
                        ) *
                        100)
                    .round();
            savingsLabel = Text(
              'Saves Rs. ${savings.toStringAsFixed(0)} ($percent%)',
              style: const TextStyle(
                fontSize: 12,
                color: _green,
                fontWeight: FontWeight.w600,
              ),
            );
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (savingsLabel != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(field.label, style: const TextStyle(fontSize: 13)),
                    savingsLabel,
                  ],
                ),
                const SizedBox(height: 6),
              ],
              TextField(
                keyboardType: field.type == FollowUpFieldType.text
                    ? TextInputType.text
                    : TextInputType.number,
                decoration: InputDecoration(
                  labelText: savingsLabel == null ? field.label : null,
                  hintText: field.placeholder,
                  prefixText: field.unitPrefix != null
                      ? '${field.unitPrefix} '
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  isDense: true,
                ),
                onChanged: (value) =>
                    controller.setFollowUpValue(questionId, field.id, value),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFreeText(Question question) {
    final length = controller.freeTextByQuestion[question.id]?.length ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller.textControllerFor(question.id),
                maxLines: 4,
                maxLength: question.maxLength,
                decoration: InputDecoration(
                  hintText: question.placeholder,
                  border: InputBorder.none,
                  counterText: '',
                ),
                onChanged: (value) =>
                    controller.setFreeText(question.id, value),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$length / ${question.maxLength ?? 0} characters',
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ),
            ],
          ),
        ),
        if (question.quickPrompts != null) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: question.quickPrompts!.map((prompt) {
              return ActionChip(
                label: Text(prompt, style: const TextStyle(fontSize: 12)),
                backgroundColor: const Color(0xFFF1EEE8),
                onPressed: () =>
                    controller.appendQuickPrompt(question.id, prompt),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoBox(Question question) {
    final infoBox = question.infoBoxFor(
      controller.selectedOptionByQuestion[question.id],
    );
    if (infoBox == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EEE8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, size: 18, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  infoBox.text,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                if (infoBox.attribution != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    infoBox.attribution!,
                    style: const TextStyle(fontSize: 11, color: Colors.black45),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- Bottom bar -------------------------------------------------------

  Widget _buildBottomBar(Question question) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: controller.canContinue ? controller.nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                disabledBackgroundColor: _green.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    question.isOptional ? 'Continue to Review' : 'Continue',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          if (question.allowSkip || question.isOptional) ...[
            const SizedBox(height: 10),
            TextButton(
              onPressed: controller.skipStep,
              child: Text(
                question.isOptional ? 'Skip for now' : 'Skip this question',
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData? _iconFor(String? name) {
    switch (name) {
      case 'alert_triangle':
        return Icons.warning_amber_rounded;
      case 'refresh':
        return Icons.autorenew;
      case 'trending_up':
        return Icons.trending_up;
      case 'bolt':
        return Icons.bolt;
      case 'gamepad':
        return Icons.sports_esports;
      case 'heart':
        return Icons.favorite_border;
      default:
        return null;
    }
  }
}
