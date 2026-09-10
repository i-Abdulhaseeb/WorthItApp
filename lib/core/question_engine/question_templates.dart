import 'package:worthitapp/data/models/question_model.dart';

const List<Question> kDecisionFlowQuestions = [
  Question(
    id: 'motivation',
    step: 1,
    totalSteps: 6,
    category: 'Motivation',
    title: 'Why do you want this?',
    subtitle: 'Your primary trigger determines how strictly our decision engine evaluates this purchase.',
    type: QuestionType.singleSelect,
    options: [
      QuestionOption(
        id: 'need_it',
        title: 'I need it',
        subtitle: 'For work, study, or an important need',
        icon: 'alert_triangle',
      ),
      QuestionOption(
        id: 'replacing_something',
        title: "I'm replacing something",
        subtitle: "My current one isn't good enough anymore",
        icon: 'refresh',
      ),
      QuestionOption(
        id: 'upgrade',
        title: "It's an upgrade",
        subtitle: 'What I have works, but I want something better',
        icon: 'trending_up',
      ),
      QuestionOption(
        id: 'convenience',
        title: 'Convenience',
        subtitle: 'It would make something easier',
        icon: 'bolt',
      ),
      QuestionOption(
        id: 'hobby',
        title: 'Hobby',
        subtitle: "I'll use it for something I enjoy",
        icon: 'gamepad',
      ),
      QuestionOption(
        id: 'just_want_it',
        title: 'I just want it',
        subtitle: 'No particular reason — I simply want it',
        icon: 'heart',
      ),
    ],
    conditionalInfoBoxByOptionId: {
      'upgrade': QuestionInfoBox(
        text: 'Selecting Upgrade will trigger an inquiry regarding the depreciation and remaining functional lifespan of your current headphones in Question 2.',
      ),
    },
  ),

  Question(
    id: 'already_own_similar',
    step: 2,
    totalSteps: 6,
    title: 'Do you already own something similar?',
    subtitle: 'Help us understand if this is an upgrade or a completely new purchase category for you.',
    type: QuestionType.singleSelect,
    allowSkip: false,
    options: [
      QuestionOption(
        id: 'yes',
        title: 'Yes',
        subtitle: 'I already have something that does this.',
      ),
      QuestionOption(
        id: 'no',
        title: 'No',
        subtitle: "I don't currently own anything similar.",
      ),
      QuestionOption(
        id: 'sort_of',
        title: 'Sort of',
        subtitle:
            "I have something similar, but it doesn't really meet my needs.",
        trailingLabel: 'Active',
      ),
    ],
    infoBox: QuestionInfoBox(
      text: 'Evaluating alternatives prevents redundant spending. 42% of audio buyers replace functional pairs prematurely.',
    ),
  ),

  // ---------------------------------------------------------------------
  // Step 3 — Usage frequency
  // ---------------------------------------------------------------------
  Question(
    id: 'usage_frequency',
    step: 3,
    totalSteps: 6,
    title: 'How often will you actually use it?',
    subtitle: 'Be realistic about how it fits into your weekly schedule.',
    type: QuestionType.singleSelect,
    options: [
      QuestionOption(
        id: 'rarely',
        title: 'Rarely',
        subtitle: 'A few times a month',
      ),
      QuestionOption(
        id: 'sometimes',
        title: 'Sometimes',
        subtitle: 'A few times a week',
      ),
      QuestionOption(id: 'often', title: 'Often', subtitle: 'Most days'),
      QuestionOption(
        id: 'almost_every_day',
        title: 'Almost every day ☀️',
        subtitle: 'It will become part of my routine',
      ),
    ],
    infoBox: QuestionInfoBox(
      text: 'Cost-per-wear logic calculates based on this answer',
    ),
  ),

  // ---------------------------------------------------------------------
  // Step 4 — Cheaper alternative
  // ---------------------------------------------------------------------
  Question(
    id: 'cheaper_alternative',
    step: 4,
    totalSteps: 6,
    category: 'Alternatives Check',
    title: 'Do you have a cheaper alternative?',
    subtitle: 'Have you considered other options that solve the same problem for less?',
    type: QuestionType.singleSelect,
    options: [
      QuestionOption(
        id: 'yes',
        title: 'Yes',
        subtitle: 'I could get something that costs less.',
        followUpFields: [
          FollowUpField(
            id: 'alternative_name',
            label: 'What is the alternative?',
            type: FollowUpFieldType.text,
            placeholder: 'e.g. Anker Soundcore Space One',
          ),
          FollowUpField(
            id: 'alternative_price',
            label: 'Approximate price',
            type: FollowUpFieldType.currency,
            unitPrefix: 'Rs.',
          ),
        ],
      ),
      QuestionOption(
        id: 'no',
        title: 'No',
        subtitle: "I haven't found a suitable cheaper option.",
      ),
      QuestionOption(
        id: 'not_sure',
        title: 'Not sure',
        subtitle: "I haven't really compared alternatives.",
      ),
    ],
    infoBox: QuestionInfoBox(
      text: "Checking a mid-tier alternative prevents buyer's remorse by assessing whether you actually need the flagship features.",
    ),
  ),

  // ---------------------------------------------------------------------
  // Step 5 — Desire & impulse
  // ---------------------------------------------------------------------
  Question(
    id: 'how_long_wanted',
    step: 5,
    totalSteps: 6,
    category: 'Desire & Impulse',
    title: 'How long have you wanted this?',
    subtitle: 'Distinguishing instant impulse from persistent genuine need.',
    type: QuestionType.singleSelect,
    options: [
      QuestionOption(
        id: 'just_today',
        title: 'Just today',
        subtitle: '',
        trailingLabel: 'Impulse',
      ),
      QuestionOption(
        id: 'a_few_days',
        title: 'A few days',
        subtitle: '',
        trailingLabel: 'Short-term',
      ),
      QuestionOption(
        id: 'a_few_weeks',
        title: 'A few weeks',
        subtitle: '',
        trailingLabel: 'Considered',
      ),
      QuestionOption(
        id: 'more_than_a_month',
        title: 'More than a month',
        subtitle: '',
        trailingLabel: 'Established',
      ),
    ],
    infoBox: QuestionInfoBox(
      text: 'Sometimes waiting reveals whether we really want something.',
      attribution: 'Decision Logic Rule #5',
    ),
  ),

  // ---------------------------------------------------------------------
  // Step 6 — Financial impact
  // ---------------------------------------------------------------------
  Question(
    id: 'financial_impact',
    step: 6,
    totalSteps: 6,
    title: 'Would buying this affect something important financially?',
    subtitle:
        'Reflect on your current obligations, emergency fund, and commitments.',
    type: QuestionType.singleSelect,
    computedBanner: ComputedBannerConfig(
      titleTemplate: '{price} ≈ {hours} hours of work',
      subtitleTemplate:
          'Based on your {income}/mo income and {workHoursPerWeek}h work week.',
    ),
    options: [
      QuestionOption(
        id: 'not_at_all',
        title: 'Not at all',
        subtitle: 'I can buy it comfortably.',
      ),
      QuestionOption(
        id: 'a_little',
        title: 'A little',
        subtitle: "I'd need to cut back somewhere.",
      ),
      QuestionOption(
        id: 'significantly',
        title: 'Significantly',
        subtitle: 'It would delay an important financial goal.',
      ),
      QuestionOption(
        id: 'not_sure',
        title: "I'm not sure",
        subtitle: "I haven't thought about the impact.",
      ),
    ],
    footerNote:
        'Calculations calibrated to your monthly discretionary surplus.',
  ),

  // ---------------------------------------------------------------------
  // Optional step — Clarifying intent
  // ---------------------------------------------------------------------
  Question(
    id: 'clarifying_intent',
    step: 0,
    totalSteps: 6,
    category: 'Clarifying Intent',
    title: "What's the main reason you're considering it?",
    subtitle: "Tell us in your own words what makes you want this right now.",
    type: QuestionType.freeText,
    isOptional: true,
    allowSkip: true,
    maxLength: 300,
    quickPrompts: [
      'Replacing broken device',
      'Work productivity upgrade',
      'Limited-time discount',
    ],
    infoBox: QuestionInfoBox(
      text: 'Your personal reasoning helps calibrate the verdict balance between emotional impulse and genuine daily utility.',
    ),
  ),
];

/// Convenience lookup by question id.
Question? findQuestionById(String id) {
  for (final q in kDecisionFlowQuestions) {
    if (q.id == id) return q;
  }
  return null;
}

/// The 6 required questions, in step order (excludes the optional step).
List<Question> get requiredDecisionFlowQuestions =>
    kDecisionFlowQuestions.where((q) => !q.isOptional).toList()
      ..sort((a, b) => a.step.compareTo(b.step));
