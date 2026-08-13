class AppValidations {
  bool isValidPhone(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  bool isValidSerial(String value) {
    return value.length > 1;
    // return RegExp(r'^[a-zA-Z0-9\-_/\.]+$').hasMatch(value);
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return "Please enter a valid email";
    }
    return null;
  }

  bool isValidText(String value) {
    return !RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]').hasMatch(value);
  }
}
