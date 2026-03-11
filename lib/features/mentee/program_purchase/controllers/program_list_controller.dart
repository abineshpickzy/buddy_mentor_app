import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/program_list_model.dart';
import '../services/program_list_service.dart';

// Export the models for easier access
export '../models/program_list_model.dart';

// Dio provider
final dioProvider = Provider<Dio>((ref) => Dio());

// Service provider
final programListServiceProvider = Provider<ProgramListService>((ref) {
  final dio = ref.read(dioProvider);
  return ProgramListService(dio);
});

// Programs AsyncNotifier
class ProgramsNotifier extends AsyncNotifier<List<Program>> {
  @override
  Future<List<Program>> build() async {
    final service = ref.read(programListServiceProvider);
    return service.getPrograms();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(programListServiceProvider);
      return service.getPrograms();
    });
  }
}

// Program Stats AsyncNotifier
class ProgramStatsNotifier extends AsyncNotifier<ProgramStats> {
  @override
  Future<ProgramStats> build() async {
    final service = ref.read(programListServiceProvider);
    return service.getProgramStats();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(programListServiceProvider);
      return service.getProgramStats();
    });
  }
}

// Providers
final programsProvider = AsyncNotifierProvider<ProgramsNotifier, List<Program>>(() {
  return ProgramsNotifier();
});

final programStatsProvider = AsyncNotifierProvider<ProgramStatsNotifier, ProgramStats>(() {
  return ProgramStatsNotifier();
});