class Validator {
  static String? validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter user name';
    }
    return null;
  }
}
