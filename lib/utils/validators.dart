class Validators {

  static String? requiredField(String? value) {

    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }

    return null;
  }

  static String? numberValidator(String? value) {

    if (value == null || value.isEmpty) {
      return "This field is required";
    }

    if (int.tryParse(value) == null) {
      return "Must be a number";
    }

    return null;
  }

  static String? positiveNumber(String? value) {

    if (value == null || value.isEmpty) {
      return "Required field";
    }

    final number = int.tryParse(value);

    if (number == null) {
      return "Must be numeric";
    }

    if (number <= 0) {
      return "Must be greater than 0";
    }

    return null;
  }

}