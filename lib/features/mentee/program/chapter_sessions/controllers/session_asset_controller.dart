import 'package:buddymentor/core/network/dio_client.dart';
import 'package:buddymentor/features/mentee/program_purchase/controllers/program_overview_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session_asset_model.dart';
import '../service/session_asset_service.dart';


// Export the models for easier access
export '../models/session_asset_model.dart';

// Service provider
final sessionAssetServiceProvider = Provider<SessionAssetService>((ref) {
  return SessionAssetService(DioClient.dio);
});

// Session Content FutureProvider with family
final sessionContentProvider = FutureProvider.family<SessionContentResponse, String>((ref, sessionId) async {
  // Get program overview to extract program type
  final programOverview = await ref.watch(programOverviewProvider.future);
  
  if (programOverview == null) {
    throw Exception('Program overview not available');
  }
  
  final service = ref.read(sessionAssetServiceProvider);
  return service.fetchSessionContent(
    programType: programOverview.program.type,
    sessionId: sessionId,
  );
});