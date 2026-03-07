class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return "Email required";
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return "Invalid email format";
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return "Password required";
    if (value.length < 6) return "Password must be at least 6 characters";
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(value)) {
      return "Password must contain uppercase,lowercase, number and symbol";
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) return "Confirm password required";
    if (value != password) return "Passwords don't match";
    return null;
  }

  static String? mobile(String? value) {
    if (value == null || value.isEmpty) return "Mobile number required";
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value.replaceAll(RegExp(r'[^0-9]'), ''))) {
      return "Invalid mobile number";
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) return "Name required";
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return "Name can only contain letters";
    }
    return null;
  }

  static String? requiredField(String? value) {
    if (value == null || value.isEmpty) return "Required";
    return null;
  }

  static String? dropdown(String? value) {
    if (value == null) return "Please select an option";
    return null;
  }
}