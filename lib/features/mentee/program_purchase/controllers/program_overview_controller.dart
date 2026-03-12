import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/program_overview_model.dart';
import '../services/program_overview_service.dart';
import '../../../../core/network/dio_client.dart';

// Export the models for easier access
export '../models/program_overview_model.dart';

// Service provider
final programOverviewServiceProvider = Provider<ProgramOverviewService>((ref) {
  return ProgramOverviewService(DioClient.dio);
});

// Program Overview AsyncNotifier
class ProgramOverviewNotifier extends AsyncNotifier<ProgramOverview?> {
  @override
  Future<ProgramOverview?> build() async {
    // Initially return null, will be populated when fetchProgram is called
    return null;
  }

  Future<void> fetchProgram(String productId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(programOverviewServiceProvider);
      return service.fetchProgram(productId);
    });
  }

  void clearProgram() {
    state = const AsyncValue.data(null);
  }
}

// Provider
final programOverviewProvider = AsyncNotifierProvider<ProgramOverviewNotifier, ProgramOverview?>(() {
  return ProgramOverviewNotifier();
});