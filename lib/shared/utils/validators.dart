class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return "Email required";
    if (!value.contains("@")) return "Invalid email";
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return "Password must be 6+ chars";
    }
    return null;
  }

  static String? requiredField(String? value) {
    if (value == null || value.isEmpty) return "Required";
    return null;
  }
}