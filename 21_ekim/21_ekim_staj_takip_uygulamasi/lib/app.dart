import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/daily_report_repository.dart';
import 'data/repositories/document_repository.dart';
import 'data/repositories/internship_repository.dart';
import 'data/repositories/review_repository.dart';
import 'data/repositories/user_repository.dart';
import 'features/auth/cubit/auth_cubit.dart';

/// StajTakip kök uygulama widget'ı.
/// Repository'leri ve üst seviye Cubit'leri enjekte eder; GoRouter ve temayı başlatır.
class StajTakipApp extends StatefulWidget {
  final AuthRepository? authRepository;
  final UserRepository? userRepository;
  final InternshipRepository? internshipRepository;
  final DailyReportRepository? dailyReportRepository;
  final ReviewRepository? reviewRepository;
  final DocumentRepository? documentRepository;

  const StajTakipApp({
    super.key,
    this.authRepository,
    this.userRepository,
    this.internshipRepository,
    this.dailyReportRepository,
    this.reviewRepository,
    this.documentRepository,
  });

  @override
  State<StajTakipApp> createState() => _StajTakipAppState();
}

class _StajTakipAppState extends State<StajTakipApp> {
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;
  late final InternshipRepository _internshipRepository;
  late final DailyReportRepository _dailyReportRepository;
  late final ReviewRepository _reviewRepository;
  late final DocumentRepository _documentRepository;

  late final AuthCubit _authCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? FirebaseAuthRepository();
    _userRepository = widget.userRepository ?? FirebaseUserRepository();
    _internshipRepository = widget.internshipRepository ?? FirebaseInternshipRepository();
    _dailyReportRepository = widget.dailyReportRepository ?? FirebaseDailyReportRepository();
    _reviewRepository = widget.reviewRepository ?? FirebaseReviewRepository();
    _documentRepository = widget.documentRepository ?? FirebaseDocumentRepository();

    _authCubit = AuthCubit(
      authRepository: _authRepository,
      userRepository: _userRepository,
    );

    _router = AppRouter.createRouter(_authCubit);
  }

  @override
  void dispose() {
    _authCubit.close();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<UserRepository>.value(value: _userRepository),
        RepositoryProvider<InternshipRepository>.value(value: _internshipRepository),
        RepositoryProvider<DailyReportRepository>.value(value: _dailyReportRepository),
        RepositoryProvider<ReviewRepository>.value(value: _reviewRepository),
        RepositoryProvider<DocumentRepository>.value(value: _documentRepository),
      ],
      child: BlocProvider<AuthCubit>.value(
        value: _authCubit,
        child: MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: _router,
        ),
      ),
    );
  }
}
