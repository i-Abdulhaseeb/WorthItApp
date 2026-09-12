/// Converts raw questionnaire selections into structured,
/// human-readable context for the decision engine.
///
/// IMPORTANT:
/// The keys in this file must match the IDs defined in
/// question_templates.dart.
const Map<String, Map<String, String>> answerInterpretations = {
  // -------------------------------------------------------------------------
  // Q1 — Motivation
  // -------------------------------------------------------------------------
  'motivation': {
    'need_it': 'The user considers this purchase necessary for an important purpose such as work, study, or another genuine need.',

    'replacing_something': 'The user is replacing an existing product because their current one is no longer good enough for their needs.',

    'upgrade': 'The user already has a functioning product but wants to upgrade to something better, suggesting the purchase is driven by improved features, performance, or experience rather than basic necessity.',

    'convenience': 'The user believes the purchase would make an existing activity easier or more convenient.',

    'hobby': 'The user is considering the purchase primarily for enjoyment or a personal hobby rather than an essential need.',

    'just_want_it': 'The user does not identify a specific practical reason for the purchase and mainly wants the product because they desire it.',
  },

  // -------------------------------------------------------------------------
  // Q2 — Existing possession
  // -------------------------------------------------------------------------
  'already_own_similar': {
    'yes': 'The user already owns a product that performs a similar function, so the new purchase may be redundant unless it provides meaningful additional value.',

    'no': 'The user does not currently own a similar product, so this would represent a new purchase category rather than a replacement or duplicate.',

    'sort_of': 'The user owns something similar, but their current product does not adequately meet their needs. The purchase may therefore be justified if the new product meaningfully solves those shortcomings.',
  },

  // -------------------------------------------------------------------------
  // Q3 — Usage frequency
  // -------------------------------------------------------------------------
  'usage_frequency': {
    'rarely': 'The user expects to use the product only a few times per month, which may reduce its practical value and increase its effective cost per use.',

    'sometimes': 'The user expects to use the product a few times per week, giving it moderate practical utility.',

    'often': 'The user expects to use the product on most days, suggesting relatively strong ongoing utility.',

    'almost_every_day': 'The user expects the product to become part of their regular routine and use it almost every day, indicating high expected utility.',
  },

  // -------------------------------------------------------------------------
  // Q4 — Cheaper alternative
  // -------------------------------------------------------------------------
  'cheaper_alternative': {
    'yes': 'The user has identified a cheaper alternative that may solve the same underlying problem for less money. The value of the more expensive product should therefore be evaluated against the additional benefits it provides.',

    'no': 'The user has not found a suitable cheaper alternative that adequately solves the same problem.',

    'not_sure': 'The user has not properly compared cheaper alternatives, so there is uncertainty about whether a less expensive option could provide sufficient value.',
  },

  // -------------------------------------------------------------------------
  // Q5 — Desire & impulse
  // -------------------------------------------------------------------------
  'how_long_wanted': {
    'just_today': 'The user has only wanted the product since today, which is a strong indicator that the purchase may be driven by a recent impulse.',

    'a_few_days': 'The user has wanted the product for a few days. The desire has persisted beyond the initial moment but may still be relatively short-term.',

    'a_few_weeks': 'The user has wanted the product for several weeks, suggesting the desire has persisted and is less likely to be purely impulsive.',

    'more_than_a_month': 'The user has wanted the product for more than a month, indicating a well-established desire that has persisted over time.',
  },

  // -------------------------------------------------------------------------
  // Q6 — Financial impact
  // -------------------------------------------------------------------------
  'financial_impact': {
    'not_at_all': 'The user believes the purchase would not negatively affect their finances and can afford it comfortably.',

    'a_little': 'The purchase is affordable but would require the user to reduce spending or make a small financial adjustment elsewhere.',

    'significantly': 'The purchase would have a meaningful financial impact and could delay an important financial goal or interfere with other financial commitments.',

    'not_sure': 'The user is uncertain about the financial impact of the purchase and has not clearly evaluated how it would affect their finances.',
  },
};

/// Returns the semantic interpretation of a selected answer.
///
/// Returns null if the question or option is not defined in the
/// interpretation map.
String? interpretAnswer({
  required String questionId,
  required String optionId,
}) {
  return answerInterpretations[questionId]?[optionId];
}
