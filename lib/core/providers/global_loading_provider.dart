import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void show() => state = true;
  void hide() => state = false;
}

final globalLoadingProvider = NotifierProvider<GlobalLoadingNotifier, bool>(
  GlobalLoadingNotifier.new,
);