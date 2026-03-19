import 'package:buddymentor/features/auth/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/program_list_model.dart';
import '../services/program_list_service.dart';
import '../../../../core/network/dio_client.dart';

// Export the models for easier access
export '../models/program_list_model.dart';

// Service provider using DioClient
final programListServiceProvider = Provider<ProgramListService>((ref) {
  return ProgramListService(DioClient.dio);
});

// Programs AsyncNotifier with controlled retry
class ProgramsNotifier extends AsyncNotifier<List<Program>> {

  
@override
Future<List<Program>> build() async {
  final auth = ref.watch(authControllerProvider);

  if (!auth.isAuthenticated || auth.user == null) {
    return [];
  }

  final service = ref.read(programListServiceProvider);

  return service.getPrograms();
}

Future<void> refresh() async {
  ref.invalidateSelf();
}
}

// Program Stats AsyncNotifier with controlled retry
class ProgramStatsNotifier extends AsyncNotifier<ProgramStats> {
  bool _hasAttempted = false;
  
  @override
  Future<ProgramStats> build() async {
    if (_hasAttempted && state.hasError) {
      // Don't retry automatically if we already failed
      throw state.error!;
    }
    
    _hasAttempted = true;
    final service = ref.read(programListServiceProvider);
    return service.getProgramStats();
  }

  Future<void> refresh() async {
    _hasAttempted = false; // Reset attempt flag for manual refresh
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