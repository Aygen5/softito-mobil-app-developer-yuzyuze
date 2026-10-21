import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../../features/auth/view/forgot_password_view.dart';
import '../../features/auth/view/login_view.dart';
import '../../features/auth/view/pending_approval_view.dart';
import '../../features/auth/view/register_view.dart';
import '../../features/approvals/view/approval_detail_view.dart';
import '../../features/approvals/view/approvals_list_view.dart';
import '../../features/approvals/view/supervised_interns_list_view.dart';
import '../../features/daily_reports/view/daily_report_form_view.dart';
import '../../features/daily_reports/view/daily_reports_list_view.dart';
import '../../features/dashboard/view/student_dashboard_view.dart';
import '../../features/documents/view/pdf_preview_view.dart';
import '../../features/internship/view/internship_progress_view.dart';
import '../../features/profile/view/reviewer_profile_view.dart';
import '../../features/profile/view/student_profile_view.dart';
import 'route_names.dart';
import 'shells/advisor_shell.dart';
import 'shells/company_shell.dart';
import 'shells/student_shell.dart';

/// GoRouter için Stream dinleyici yardımcı sınıfı.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// StajTakip merkezi GoRouter yapılandırması ve rol tabanlı korumalı rota yöneticisi.
abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');

  static GoRouter createRouter(AuthCubit authCubit) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: RouteNames.login,
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: (context, state) {
        final authState = authCubit.state;
        final location = state.matchedLocation;

        final isAuthRoute = location == RouteNames.login ||
            location == RouteNames.register ||
            location == RouteNames.forgotPassword;

        // 1. Durum henüz yükleniyor veya başlangıçta ise yönlendirme yapma
        if (authState is AuthInitial || (authState is AuthLoading && authState.message == null)) {
          return null;
        }

        // 2. Kullanıcı giriş yapmamışsa
        if (authState is Unauthenticated || authState is AuthError) {
          return isAuthRoute ? null : RouteNames.login;
        }

        // 3. Kullanıcı hesabı var ancak onay/profil bekliyorsa
        if (authState is AuthPendingApproval) {
          return location == RouteNames.pendingApproval ? null : RouteNames.pendingApproval;
        }

        // 4. Kullanıcı başarıyla doğrulanmışsa
        if (authState is Authenticated) {
          final user = authState.user;
          final role = user.role;

          // Giriş veya onay ekranındaysa kendi ana paneline yönlendir
          if (isAuthRoute || location == RouteNames.pendingApproval) {
            if (role.isStudent) return RouteNames.studentHome;
            if (role.isAcademicAdvisor) return RouteNames.advisorPending;
            if (role.isCompanyRepresentative) return RouteNames.companyPending;
            return RouteNames.pendingApproval;
          }

          // Yetkisiz rota erişim kontrolü (URL üzerinden doğrudan erişim koruması)
          if (role.isStudent && (location.startsWith('/advisor') || location.startsWith('/company'))) {
            return RouteNames.studentHome;
          }
          if (role.isAcademicAdvisor && (location.startsWith('/student') || location.startsWith('/company'))) {
            return RouteNames.advisorPending;
          }
          if (role.isCompanyRepresentative && (location.startsWith('/student') || location.startsWith('/advisor'))) {
            return RouteNames.companyPending;
          }
        }

        return null;
      },
      routes: [
        // Kimlik Doğrulama Rotaları
        GoRoute(
          path: RouteNames.login,
          name: RouteNames.loginName,
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          path: RouteNames.register,
          name: RouteNames.registerName,
          builder: (context, state) => const RegisterView(),
        ),
        GoRoute(
          path: RouteNames.forgotPassword,
          name: RouteNames.forgotPasswordName,
          builder: (context, state) => const ForgotPasswordView(),
        ),
        GoRoute(
          path: RouteNames.pendingApproval,
          name: RouteNames.pendingApprovalName,
          builder: (context, state) => const PendingApprovalView(),
        ),

        // Öğrenci Alt Menülü Rotaları (StatefulShellRoute.indexedStack)
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return StudentShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.studentHome,
                  name: RouteNames.studentHomeName,
                  builder: (context, state) => const StudentDashboardView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.studentJournal,
                  name: RouteNames.studentJournalName,
                  builder: (context, state) => const DailyReportsListView(),
                  routes: [
                    GoRoute(
                      path: 'form',
                      name: RouteNames.studentReportFormName,
                      builder: (context, state) => DailyReportFormView(
                        extra: state.extra,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.studentProgress,
                  name: RouteNames.studentProgressName,
                  builder: (context, state) => const InternshipProgressView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.studentProfile,
                  name: RouteNames.studentProfileName,
                  builder: (context, state) => const StudentProfileView(),
                ),
              ],
            ),
          ],
        ),

        // Ortak Onay Detay Ekranı (Ekran 4)
        GoRoute(
          path: RouteNames.approvalDetail,
          name: RouteNames.approvalDetailName,
          builder: (context, state) => ApprovalDetailView(
            extra: state.extra,
          ),
        ),

        // PDF Staj Defteri Önizleme Rotası (Ekran 6)
        GoRoute(
          path: RouteNames.studentPdfPreview,
          name: RouteNames.studentPdfPreviewName,
          builder: (context, state) => PdfPreviewView(
            internshipId: state.extra as String? ?? '',
          ),
        ),

        // Akademik Danışman Alt Menülü Rotaları
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AdvisorShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.advisorPending,
                  name: RouteNames.advisorPendingName,
                  builder: (context, state) => const ApprovalsListView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.advisorStudents,
                  name: RouteNames.advisorStudentsName,
                  builder: (context, state) =>
                      const SupervisedInternsListView(title: 'Öğrencilerim'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.advisorProfile,
                  name: RouteNames.advisorProfileName,
                  builder: (context, state) =>
                      const ReviewerProfileView(title: 'Danışman Profili'),
                ),
              ],
            ),
          ],
        ),

        // Şirket Yetkilisi Alt Menülü Rotaları
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return CompanyShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.companyPending,
                  name: RouteNames.companyPendingName,
                  builder: (context, state) => const ApprovalsListView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.companyInterns,
                  name: RouteNames.companyInternsName,
                  builder: (context, state) =>
                      const SupervisedInternsListView(title: 'Stajyerlerim'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.companyProfile,
                  name: RouteNames.companyProfileName,
                  builder: (context, state) =>
                      const ReviewerProfileView(title: 'Yetkili Profili'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
