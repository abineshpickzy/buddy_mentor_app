import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Model to hold selected program identifiers
class SelectedProgram {
  final String programId;
  final String productId;
  final int productType;
  final bool isFreeTrial;

  SelectedProgram({
    required this.programId,
    required this.productId,
    required this.productType,
    required this.isFreeTrial,
  });

  // Copy with for immutability
  SelectedProgram copyWith({
    String? programId,
    String? productId,
    int? productType,
    bool? isFreeTrial,
  }) {
    return SelectedProgram(
      programId: programId ?? this.programId,
      productId: productId ?? this.productId,
      productType: productType ?? this.productType,
      isFreeTrial: isFreeTrial ?? this.isFreeTrial,
    );
  }
}

/// Notifier to manage selected program (Riverpod 3 syntax)
class SelectedProgramNotifier extends Notifier<SelectedProgram?> {
  @override
  SelectedProgram? build() {
    return null; // Initially no program selected
  }

  /// Set the selected program when user clicks on a program card
  void selectProgram({
    required String programId,
    required String productId,
    required int productType,
    required bool isFreeTrial,
  }) {
    state = SelectedProgram(
      programId: programId,
      productId: productId,
      productType: productType,
      isFreeTrial: isFreeTrial,
    );
  }

  /// Clear selection (on logout, etc.)
  void clearSelection() {
    state = null;
  }
}

/// Provider to manage selected program globally (Riverpod 3 syntax)
final selectedProgramProvider =
    NotifierProvider<SelectedProgramNotifier, SelectedProgram?>(
  () => SelectedProgramNotifier(),
);