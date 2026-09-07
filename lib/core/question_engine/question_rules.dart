/// Rules determining question routing logic
class QuestionRules {
  bool shouldTriggerImpulseCheck(double price, double monthlyIncome) {
    if (monthlyIncome <= 0) return price > 50;
    return (price / monthlyIncome) > 0.05;
  }
}
