/// Form input validators
class Validators {
  Validators._();

  static String? requiredField(String? value, {String message = 'This field is required'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? positiveNumber(String? value, {String message = 'Enter a valid positive number'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    final num = double.tryParse(value);
    if (num == null || num <= 0) {
      return message;
    }
    return null;
  }
}
