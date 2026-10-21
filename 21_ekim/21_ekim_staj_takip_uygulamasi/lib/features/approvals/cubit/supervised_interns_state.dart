import 'package:equatable/equatable.dart';
import '../../../data/models/internship_model.dart';
import '../../../data/models/user_model.dart';

class InternProgressItem extends Equatable {
  final InternshipModel internship;
  final UserModel student;
  final int approvedDays;
  final double progressRatio;

  const InternProgressItem({
    required this.internship,
    required this.student,
    required this.approvedDays,
    required this.progressRatio,
  });

  @override
  List<Object?> get props => [internship, student, approvedDays, progressRatio];
}

sealed class SupervisedInternsState extends Equatable {
  const SupervisedInternsState();

  @override
  List<Object?> get props => [];
}

class SupervisedInternsInitial extends SupervisedInternsState {
  const SupervisedInternsInitial();
}

class SupervisedInternsLoading extends SupervisedInternsState {
  const SupervisedInternsLoading();
}

class SupervisedInternsLoaded extends SupervisedInternsState {
  final List<InternProgressItem> items;

  const SupervisedInternsLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class SupervisedInternsEmpty extends SupervisedInternsState {
  final String message;

  const SupervisedInternsEmpty({
    this.message = 'Henüz atanmış öğrenci veya stajyer bulunmamaktadır.',
  });

  @override
  List<Object?> get props => [message];
}

class SupervisedInternsError extends SupervisedInternsState {
  final String message;

  const SupervisedInternsError(this.message);

  @override
  List<Object?> get props => [message];
}
