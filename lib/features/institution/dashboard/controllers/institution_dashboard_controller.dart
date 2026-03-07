import 'package:flutter_riverpod/flutter_riverpod.dart';

class InstitutionDashboardController extends Notifier<void> {
  @override
  void build() {}
}

final institutionDashboardControllerProvider = NotifierProvider<InstitutionDashboardController, void>(
  InstitutionDashboardController.new,
);