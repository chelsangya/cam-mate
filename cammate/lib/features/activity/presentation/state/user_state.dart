import 'package:cammate/features/user/data/model/user_model.dart';

class UserState {
  final bool isLoading;
  final String? error;
  final bool showMessage;
  final String? message;
  final List<UserAPIModel> users;
  final UserAPIModel? selectedUser;

  UserState({
    required this.isLoading,
    this.error,
    this.message,
    this.showMessage = false,
    this.users = const [],
    this.selectedUser,
  });

  factory UserState.initialState() {
    return UserState(isLoading: false, error: null, showMessage: false, users: const []);
  }

  UserState copyWith({
    bool? isLoading,
    String? error,
    bool? showMessage,
    String? message,
    List<UserAPIModel>? users,
    UserAPIModel? selectedUser,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      showMessage: showMessage ?? this.showMessage,
      message: message ?? this.message,
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }

  @override
  String toString() => 'UserState(isLoading: $isLoading, error: $error, users: ${users.length})';
}
