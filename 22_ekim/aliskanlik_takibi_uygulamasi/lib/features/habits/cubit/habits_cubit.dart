import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aliskanlik_takibi_uygulamasi/data/repositories/habit_repository.dart';
import 'package:aliskanlik_takibi_uygulamasi/models/habit.dart';
import 'package:aliskanlik_takibi_uygulamasi/services/notification_service.dart';

import 'habits_state.dart';

class HabitsCubit extends Cubit<HabitsState> {
  final HabitRepository _habitRepository;
  final NotificationService _notificationService = NotificationService();
  StreamSubscription? _habitsSub;

  HabitsCubit({required HabitRepository habitRepository})
    : _habitRepository = habitRepository,
      super(HabitsState(habits: habitRepository.getHabits())) {
    _habitsSub = _habitRepository.habitsStream.listen((habits) {
      emit(state.copyWith(habits: habits));
    });
  }

  Future<void> addHabit(Habit habit) async {
    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );
    try {
      await _habitRepository.addHabit(habit);

      if (habit.reminderEnabled && habit.reminderTime != null) {
        await _notificationService.scheduleHabitReminder(
          notificationId: habit.id.hashCode,
          habitTitle: habit.title,
          timeString: habit.reminderTime!,
        );
      }

      emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'Alışkanlık başarıyla oluşturuldu.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Alışkanlık eklenirken bir hata oluştu.',
        ),
      );
    }
  }

  Future<void> updateHabit(Habit habit) async {
    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );
    try {
      await _habitRepository.updateHabit(habit);

      if (habit.reminderEnabled && habit.reminderTime != null) {
        await _notificationService.scheduleHabitReminder(
          notificationId: habit.id.hashCode,
          habitTitle: habit.title,
          timeString: habit.reminderTime!,
        );
      } else {
        await _notificationService.cancelReminder(habit.id.hashCode);
      }

      emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'Alışkanlık güncellendi.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Güncelleme başarısız oldu.',
        ),
      );
    }
  }

  Future<void> deleteHabit(String habitId) async {
    emit(
      state.copyWith(isLoading: true, errorMessage: null, successMessage: null),
    );
    try {
      await _habitRepository.deleteHabit(habitId);
      await _notificationService.cancelReminder(habitId.hashCode);
      emit(
        state.copyWith(isLoading: false, successMessage: 'Alışkanlık silindi.'),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Silme işlemi başarısız oldu.',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _habitsSub?.cancel();
    return super.close();
  }
}
