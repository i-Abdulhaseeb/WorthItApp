enum QuestionType { singleSelect, freeText }

enum FollowUpFieldType { text, number, currency }

class FollowUpField {
  final String id;
  final String label;
  final FollowUpFieldType type;
  final String? placeholder;
  final String? unitPrefix;

  const FollowUpField({
    required this.id,
    required this.label,
    required this.type,
    this.placeholder,
    this.unitPrefix,
  });

  factory FollowUpField.fromJson(Map<String, dynamic> json) {
    return FollowUpField(
      id: json['id'] as String,
      label: json['label'] as String,
      type: FollowUpFieldType.values.byName(json['type'] as String),
      placeholder: json['placeholder'] as String?,
      unitPrefix: json['unitPrefix'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'type': type.name,
    if (placeholder != null) 'placeholder': placeholder,
    if (unitPrefix != null) 'unitPrefix': unitPrefix,
  };
}

class QuestionInfoBox {
  final String text;
  final String? attribution;

  const QuestionInfoBox({required this.text, this.attribution});

  factory QuestionInfoBox.fromJson(Map<String, dynamic> json) {
    return QuestionInfoBox(
      text: json['text'] as String,
      attribution: json['attribution'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    if (attribution != null) 'attribution': attribution,
  };
}

class ComputedBannerConfig {
  final String titleTemplate;

  final String subtitleTemplate;

  const ComputedBannerConfig({
    required this.titleTemplate,
    required this.subtitleTemplate,
  });

  factory ComputedBannerConfig.fromJson(Map<String, dynamic> json) {
    return ComputedBannerConfig(
      titleTemplate: json['titleTemplate'] as String,
      subtitleTemplate: json['subtitleTemplate'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'titleTemplate': titleTemplate,
    'subtitleTemplate': subtitleTemplate,
  };
}

class QuestionOption {
  final String id;
  final String title;
  final String subtitle;

  /// Logical icon identifier (e.g. "alert", "refresh", "trending_up").
  /// The UI layer maps this to an actual icon/asset.
  final String? icon;

  /// Small label rendered next to/under the option when relevant, e.g.
  /// "Active" (Q2), "Impulse" / "Considered" / "Established" (Q5),
  /// "Selected" (Q4/Q6).
  final String? trailingLabel;

  /// Nested inputs revealed only when this option is selected
  /// (e.g. Q4's "Yes" -> alternative name + approx price).
  final List<FollowUpField> followUpFields;

  const QuestionOption({
    required this.id,
    required this.title,
    required this.subtitle,
    this.icon,
    this.trailingLabel,
    this.followUpFields = const [],
  });

  bool get hasFollowUpFields => followUpFields.isNotEmpty;

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      icon: json['icon'] as String?,
      trailingLabel: json['trailingLabel'] as String?,
      followUpFields: (json['followUpFields'] as List<dynamic>? ?? [])
          .map((e) => FollowUpField.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    if (icon != null) 'icon': icon,
    if (trailingLabel != null) 'trailingLabel': trailingLabel,
    if (followUpFields.isNotEmpty)
      'followUpFields': followUpFields.map((f) => f.toJson()).toList(),
  };
}

// ---------------------------------------------------------------------------
// Question
// ---------------------------------------------------------------------------

class Question {
  final String id;
  final int step; // 1-based, e.g. 1..6, or 0 for the optional step
  final int totalSteps; // e.g. 6
  final String? category; // e.g. "Motivation", "Alternatives Check"
  final String title;
  final String? subtitle;
  final QuestionType type;

  /// True for the "Clarifying Intent" step, which is skippable and not
  /// counted toward the required 6.
  final bool isOptional;

  /// True if the UI should show a "Skip this question" / "Skip for now"
  /// affordance even though it isn't necessarily optional overall (Q2).
  final bool allowSkip;

  // --- singleSelect-specific ---
  final List<QuestionOption> options;
  final QuestionInfoBox? infoBox;

  /// Q1-style behavior: the info box content changes depending on which
  /// option is currently selected. Keyed by QuestionOption.id.
  final Map<String, QuestionInfoBox>? conditionalInfoBoxByOptionId;

  final ComputedBannerConfig? computedBanner;

  // --- freeText-specific ---
  final String? placeholder;
  final int? maxLength;
  final List<String>? quickPrompts;
  final String? footerNote;

  const Question({
    required this.id,
    required this.step,
    required this.totalSteps,
    required this.title,
    required this.type,
    this.category,
    this.subtitle,
    this.isOptional = false,
    this.allowSkip = false,
    this.options = const [],
    this.infoBox,
    this.conditionalInfoBoxByOptionId,
    this.computedBanner,
    this.placeholder,
    this.maxLength,
    this.quickPrompts,
    this.footerNote,
  });

  QuestionOption? optionById(String optionId) {
    for (final o in options) {
      if (o.id == optionId) return o;
    }
    return null;
  }

  QuestionInfoBox? infoBoxFor(String? selectedOptionId) {
    if (selectedOptionId != null &&
        conditionalInfoBoxByOptionId != null &&
        conditionalInfoBoxByOptionId!.containsKey(selectedOptionId)) {
      return conditionalInfoBoxByOptionId![selectedOptionId];
    }
    return infoBox;
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      step: json['step'] as int,
      totalSteps: json['totalSteps'] as int,
      category: json['category'] as String?,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      type: QuestionType.values.byName(json['type'] as String),
      isOptional: json['isOptional'] as bool? ?? false,
      allowSkip: json['allowSkip'] as bool? ?? false,
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      infoBox: json['infoBox'] != null
          ? QuestionInfoBox.fromJson(json['infoBox'] as Map<String, dynamic>)
          : null,
      conditionalInfoBoxByOptionId:
          (json['conditionalInfoBoxByOptionId'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(
              k,
              QuestionInfoBox.fromJson(v as Map<String, dynamic>),
            ),
          ),
      computedBanner: json['computedBanner'] != null
          ? ComputedBannerConfig.fromJson(
              json['computedBanner'] as Map<String, dynamic>,
            )
          : null,
      placeholder: json['placeholder'] as String?,
      maxLength: json['maxLength'] as int?,
      quickPrompts: (json['quickPrompts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      footerNote: json['footerNote'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'step': step,
    'totalSteps': totalSteps,
    if (category != null) 'category': category,
    'title': title,
    if (subtitle != null) 'subtitle': subtitle,
    'type': type.name,
    'isOptional': isOptional,
    'allowSkip': allowSkip,
    if (options.isNotEmpty) 'options': options.map((o) => o.toJson()).toList(),
    if (infoBox != null) 'infoBox': infoBox!.toJson(),
    if (conditionalInfoBoxByOptionId != null)
      'conditionalInfoBoxByOptionId': conditionalInfoBoxByOptionId!.map(
        (k, v) => MapEntry(k, v.toJson()),
      ),
    if (computedBanner != null) 'computedBanner': computedBanner!.toJson(),
    if (placeholder != null) 'placeholder': placeholder,
    if (maxLength != null) 'maxLength': maxLength,
    if (quickPrompts != null) 'quickPrompts': quickPrompts,
    if (footerNote != null) 'footerNote': footerNote,
  };
}
