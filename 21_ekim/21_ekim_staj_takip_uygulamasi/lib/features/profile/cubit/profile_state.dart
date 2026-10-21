import 'package:equatable/equatable.dart';
import '../../../data/models/internship_model.dart';
import '../../../data/models/user_model.dart';

/// Profil ekranı durumları.
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final InternshipModel? activeInternship;

  const ProfileLoaded({
    required this.user,
    this.activeInternship,
  });

  @override
  List<Object?> get props => [user, activeInternship];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
