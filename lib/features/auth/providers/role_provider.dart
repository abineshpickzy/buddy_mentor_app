import 'package:flutter_riverpod/flutter_riverpod.dart ';

class RoleNotifier extends Notifier<String> {
  @override
  String build() {
    return "";
  }

  void setRole(String role) {
    state = role;
  }

  String getRole() {
    return state;
  }
  void removeRole() {
    state = "";
  }
}

final roleProvider = NotifierProvider<RoleNotifier, String>(RoleNotifier.new);
