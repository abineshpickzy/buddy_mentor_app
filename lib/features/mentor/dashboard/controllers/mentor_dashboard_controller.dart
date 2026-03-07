import 'package:flutter_riverpod/flutter_riverpod.dart';

class MentorDashboardController extends Notifier<void> {
  @override
  void build() {}
}

final mentorDashboardControllerProvider = NotifierProvider<MentorDashboardController, void>(
  MentorDashboardController.new,
);