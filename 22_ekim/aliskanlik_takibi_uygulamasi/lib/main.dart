import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/habit_repository.dart';
import 'data/repositories/habit_repository_impl.dart';
import 'data/repositories/statistics_repository.dart';
import 'data/repositories/statistics_repository_impl.dart';
import 'features/calendar/cubit/calendar_cubit.dart';
import 'features/habits/cubit/habits_cubit.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/onboarding/cubit/onboarding_cubit.dart';
import 'features/statistics/cubit/statistics_cubit.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sistem çubuğu renkleri
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Yerel bildirim servisi başlatma (sessiz ve hatasız)
  await NotificationService().initialize();

  // Repository Örnekleri
  final habitRepository = HabitRepositoryImpl();
  final statisticsRepository = StatisticsRepositoryImpl(
    habitRepository: habitRepository,
  );

  runApp(
    VerdantApp(
      habitRepository: habitRepository,
      statisticsRepository: statisticsRepository,
    ),
  );
}

class VerdantApp extends StatelessWidget {
  final HabitRepository habitRepository;
  final StatisticsRepository statisticsRepository;

  const VerdantApp({
    super.key,
    required this.habitRepository,
    required this.statisticsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HabitRepository>.value(value: habitRepository),
        RepositoryProvider<StatisticsRepository>.value(
          value: statisticsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<OnboardingCubit>(create: (context) => OnboardingCubit()),
          BlocProvider<HomeCubit>(
            create: (context) => HomeCubit(habitRepository: habitRepository),
          ),
          BlocProvider<HabitsCubit>(
            create: (context) => HabitsCubit(habitRepository: habitRepository),
          ),
          BlocProvider<CalendarCubit>(
            create: (context) =>
                CalendarCubit(habitRepository: habitRepository),
          ),
          BlocProvider<StatisticsCubit>(
            create: (context) => StatisticsCubit(
              statisticsRepository: statisticsRepository,
              habitRepository: habitRepository,
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Verdant',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
