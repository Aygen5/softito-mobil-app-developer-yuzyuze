import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/failure.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../../data/repositories/user_repository.dart';
import 'profile_state.dart';

/// Kullanıcı profil yönetimi ve oturum kapatma Cubit'i.
class ProfileCubit extends Cubit<ProfileState> {
  final UserModel initialUser;
  final UserRepository userRepository;
  final InternshipRepository internshipRepository;
  final AuthRepository authRepository;

  ProfileCubit({
    required this.initialUser,
    required this.userRepository,
    required this.internshipRepository,
    required this.authRepository,
  }) : super(const ProfileInitial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    try {
      final user =
          await userRepository.getUserProfile(initialUser.uid) ?? initialUser;
      final internship =
          await internshipRepository.getActiveInternshipForStudent(user.uid);

      emit(ProfileLoaded(user: user, activeInternship: internship));
    } on Failure catch (e) {
      emit(ProfileError(e.message));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await authRepository.signOut();
    } on Failure catch (e) {
      emit(ProfileError(e.message));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
