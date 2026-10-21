import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/empty_view.dart';
import '../../../common/widgets/error_view.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../common/widgets/progress_card.dart';
import '../../../common/widgets/theme_toggle_button.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/supervised_interns_cubit.dart';
import '../cubit/supervised_interns_state.dart';

/// Yetkiliye atanmış stajyerlerin/öğrencilerin listelendiği ekran (Stitch Redesign).
class SupervisedInternsListView extends StatelessWidget {
  final String title;

  const SupervisedInternsListView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
        backgroundColor: isDark
            ? const Color(0xFF0B1120)
            : const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.school_rounded,
                    color: Color(0xFF38BDF8),
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          actions: const [ThemeToggleButton(), SizedBox(width: 8)],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF161F30) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF283548)
        : const Color(0xFFE2E8F0);

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = items[index];
                final student = item.student;
                final internship = item.internship;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.2 : 0.03,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: const Color(0xFF2563EB),
                            child: Text(
                              student.fullName.isNotEmpty
                                  ? student.fullName[0].toUpperCase()
                                  : 'Ö',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      student.fullName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.verified_rounded,
                                      size: 15,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Öğrenci No: ${student.institutionId ?? '150200142'} • ${internship.companyName}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.date_range_outlined,
                              size: 14,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Staj Aralığı: ${DateFormatter.formatDateTurkish(internship.startDate)} — ${DateFormatter.formatDateTurkish(internship.endDate)}',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ProgressCard(
                        title: 'Zorunlu Staj İlerlemesi',
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
