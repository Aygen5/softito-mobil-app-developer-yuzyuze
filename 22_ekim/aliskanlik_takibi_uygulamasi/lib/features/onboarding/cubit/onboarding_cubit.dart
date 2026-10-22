import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingState {
  final bool isLoading;
  final bool isDemoActive;
  final String? errorMessage;

  const OnboardingState({
    this.isLoading = false,
    this.isDemoActive = false,
    this.errorMessage,
  });

  OnboardingState copyWith({
    bool? isLoading,
    bool? isDemoActive,
    String? errorMessage,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      isDemoActive: isDemoActive ?? this.isDemoActive,
      errorMessage: errorMessage,
    );
  }
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void continueAsDemo() {
    emit(state.copyWith(isLoading: true));
    // Demo akışı doğrudan ana ekrana yönlendirir
    emit(state.copyWith(isLoading: false, isDemoActive: true));
  }

  void login(String email, String password) {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Lütfen e-posta ve parolanızı girin.'));
      return;
    }
    emit(state.copyWith(isLoading: true, errorMessage: null));
    emit(state.copyWith(isLoading: false, isDemoActive: true));
  }

  void register(String fullName, String email, String password) {
    if (fullName.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      emit(
        state.copyWith(errorMessage: 'Lütfen tüm alanları eksiksiz doldurun.'),
      );
      return;
    }
    emit(state.copyWith(isLoading: true, errorMessage: null));
    emit(state.copyWith(isLoading: false, isDemoActive: true));
  }
}
