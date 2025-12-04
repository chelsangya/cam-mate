import 'package:cammate/features/mart/data/model/mart_model.dart';

class MartState {
  final bool isLoading;
  final String? error;
  final bool showMessage;
  final String? message;
  final List<MartAPIModel> marts;
  final MartAPIModel? selectedMart;

  MartState({
    required this.isLoading,
    this.error,
    this.message,
    this.showMessage = false,
    this.marts = const [],
    this.selectedMart,
  });

  factory MartState.initialState() {
    return MartState(isLoading: false, error: null, showMessage: false, marts: const []);
  }

  MartState copyWith({
    bool? isLoading,
    String? error,
    bool? showMessage,
    String? message,
    List<MartAPIModel>? marts,
    MartAPIModel? selectedMart,
  }) {
    return MartState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      showMessage: showMessage ?? this.showMessage,
      message: message ?? this.message,
      marts: marts ?? this.marts,
      selectedMart: selectedMart ?? this.selectedMart,
    );
  }

  @override
  String toString() => 'MartState(isLoading: $isLoading, error: $error, marts: ${marts.length})';
}
