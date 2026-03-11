import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:buddymentor/core/network/dio_client.dart';
import 'package:buddymentor/core/network/api_endpoints.dart';
import 'package:buddymentor/features/mentee/dashboard/services/mentee_program_service.dart';

class ProgramOverviewNotifier extends AsyncNotifier<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>> build() async {
    return fetchProgramOverview();
  }

  Future<Map<String, dynamic>> fetchProgramOverview() async {
    state = const AsyncValue.loading();
    try {
      final response = await MenteeProgramService.fetchProgramOverview();
      final programOverview = response.data as Map<String, dynamic>;
      state = AsyncValue.data(programOverview['data']);
      return programOverview['data'];
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

final programOverviewProvider = AsyncNotifierProvider<ProgramOverviewNotifier, Map<String, dynamic>>(
  () => ProgramOverviewNotifier(),
);