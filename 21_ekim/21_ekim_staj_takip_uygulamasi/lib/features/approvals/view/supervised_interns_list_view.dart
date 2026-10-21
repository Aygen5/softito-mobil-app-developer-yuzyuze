import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/empty_view.dart';
import '../../../common/widgets/error_view.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../common/widgets/progress_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/supervised_interns_cubit.dart';
import '../cubit/supervised_interns_state.dart';

/// Yetkiliye atanmış stajyerlerin/öğrencilerin listelendiği ekran.
class SupervisedInternsListView extends StatelessWidget {
  final String title;

  const SupervisedInternsListView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final reviewer = authState.currentUser;

    if (reviewer == null) {
      return const Scaffold(
        body: Center(child: LoadingView(message: 'Oturum yükleniyor...')),
      );
    }

    return BlocProvider<SupervisedInternsCubit>(
      create: (context) => SupervisedInternsCubit(
        reviewerId: reviewer.uid,
        reviewerRole: reviewer.role,
        internshipRepository: context.read<InternshipRepository>(),
        dailyReportRepository: context.read<DailyReportRepository>(),
        userRepository: context.read<UserRepository>(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
          title: Text(
            title,
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
          ),
        ),
        body: const _InternsBody(),
      ),
    );
  }
}

class _InternsBody extends StatelessWidget {
  const _InternsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupervisedInternsCubit, SupervisedInternsState>(
      builder: (context, state) {
        if (state is SupervisedInternsLoading ||
            state is SupervisedInternsInitial) {
          return const LoadingView(message: 'Öğrenci listesi alınıyor...');
        }

        if (state is SupervisedInternsError) {
          return ErrorView(
            message: state.message,
            onRetry: () => context.read<SupervisedInternsCubit>().refresh(),
          );
        }

        if (state is SupervisedInternsEmpty) {
          return RefreshIndicator(
            onRefresh: () => context.read<SupervisedInternsCubit>().refresh(),
            child: ListView(
              children: [
                const SizedBox(height: 60),
                EmptyView(
                  icon: Icons.people_outline_rounded,
                  title: 'Atanmış Öğrenci Yok',
                  message: state.message,
                ),
              ],
            ),
          );
        }

        if (state is SupervisedInternsLoaded) {
          final items = state.items;

          return RefreshIndicator(
            onRefresh: () => context.read<SupervisedInternsCubit>().refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = items[index];
                final student = item.student;
                final internship = item.internship;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.primaryBlue.withValues(
                              alpha: 0.12,
                            ),
                            child: Text(
                              student.fullName.isNotEmpty
                                  ? student.fullName[0].toUpperCase()
                                  : 'Ö',
                              style: AppTextStyles.cardTitle.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.fullName,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Öğrenci No: ${student.institutionId ?? '-'} • ${internship.companyName}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Staj Aralığı: ${DateFormatter.formatDateTurkish(internship.startDate)} — ${DateFormatter.formatDateTurkish(internship.endDate)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ProgressCard(
                        title: 'Staj İlerlemesi',
                        completedDays: item.approvedDays,
                        requiredDays: internship.requiredDays,
                        progressRatio: item.progressRatio,
                        subtitle:
                            'Onaylanan: ${item.approvedDays} / ${internship.requiredDays} Gün',
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
