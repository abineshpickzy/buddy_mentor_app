import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndustryDashboardController extends Notifier<void> {
  @override
  void build() {}
}

final industryDashboardControllerProvider = NotifierProvider<IndustryDashboardController, void>(
  IndustryDashboardController.new,
);