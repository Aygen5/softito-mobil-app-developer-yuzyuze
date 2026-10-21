import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failure.dart';
import '../../../core/utils/workday_calculator.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/document_repository.dart';
import 'daily_report_form_state.dart';

/// Rapor oluşturma ve düzenleme Cubit'i.
class DailyReportFormCubit extends Cubit<DailyReportFormState> {
  final String internshipId;
  final String studentId;
  final DailyReportModel? initialReport;
  final DailyReportRepository dailyReportRepository;
  final DocumentRepository documentRepository;

  DailyReportFormCubit({
    required this.internshipId,
    required this.studentId,
    this.initialReport,
    required this.dailyReportRepository,
    required this.documentRepository,
  }) : super(const DailyReportFormInitial()) {
    _init();
  }

  void _init() {
    if (initialReport != null) {
      emit(
        DailyReportFormReady(
          workDate: initialReport!.workDate,
          hoursWorked: initialReport!.hoursWorked,
          tasks: initialReport!.tasks,
          learnings: initialReport!.learnings,
          attachmentPaths: List.from(initialReport!.attachmentPaths),
          initialReport: initialReport,
        ),
      );
    } else {
      // Varsayılan olarak bugünü seç (hafta sonuysa en yakın önceki cuma)
      DateTime defaultDate = DateTime.now();
      if (defaultDate.weekday == DateTime.saturday) {
        defaultDate = defaultDate.subtract(const Duration(days: 1));
      } else if (defaultDate.weekday == DateTime.sunday) {
        defaultDate = defaultDate.subtract(const Duration(days: 2));
      }

      emit(
        DailyReportFormReady(
          workDate: DateTime(
            defaultDate.year,
            defaultDate.month,
            defaultDate.day,
          ),
          hoursWorked: 8,
          tasks: '',
          learnings: '',
          attachmentPaths: const [],
        ),
      );
    }
  }

  Future<void> updateWorkDate(DateTime newDate) async {
    final currentState = state;
    if (currentState is! DailyReportFormReady) return;

    final normalized = DateTime(newDate.year, newDate.month, newDate.day);

    if (WorkdayCalculator.isWeekend(normalized)) {
      emit(
        currentState.copyWith(
          workDate: normalized,
          dateError: () => 'Hafta sonu günlerine rapor girilemez.',
        ),
      );
      return;
    }

    // Mükerrer rapor kontrolü
    try {
      final exists = await dailyReportRepository.hasReportOnDate(
        internshipId: internshipId,
        date: normalized,
        excludeReportId: initialReport?.id,
      );

      if (exists) {
        emit(
          currentState.copyWith(
            workDate: normalized,
            dateError: () =>
                'Bu tarihte zaten kayıtlı bir raporunuz bulunmaktadır.',
          ),
        );
      } else {
        emit(
          currentState.copyWith(workDate: normalized, dateError: () => null),
        );
      }
    } catch (_) {
      emit(currentState.copyWith(workDate: normalized, dateError: () => null));
    }
  }

  void updateHours(int hours) {
    final currentState = state;
    if (currentState is! DailyReportFormReady) return;
    emit(currentState.copyWith(hoursWorked: hours));
  }

  void updateTasks(String tasks) {
    final currentState = state;
    if (currentState is! DailyReportFormReady) return;
    emit(currentState.copyWith(tasks: tasks));
  }

  void updateLearnings(String learnings) {
    final currentState = state;
    if (currentState is! DailyReportFormReady) return;
    emit(currentState.copyWith(learnings: learnings));
  }

  Future<void> pickAndUploadAttachment() async {
    final currentState = state;
    if (currentState is! DailyReportFormReady) return;

    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (files.isEmpty) return;

      final file = files.first;
      final bytes = await file.xFile.readAsBytes();

      if (bytes.length > AppConstants.maxFileSizeBytes) {
        emit(
          const DailyReportFormFailure(
            'Seçilen dosya boyutu 10 MB sınırını aşamaz.',
          ),
        );
        emit(currentState);
        return;
      }

      emit(currentState.copyWith(isUploadingAttachment: true));

      final downloadUrl = await documentRepository.uploadFile(
        path:
            'internships/$internshipId/reports/${DateTime.now().millisecondsSinceEpoch}_${file.name}',
        bytes: bytes,
        fileName: file.name,
      );

      final updatedAttachments = List<String>.from(currentState.attachmentPaths)
        ..add(downloadUrl);

      emit(
        currentState.copyWith(
          attachmentPaths: updatedAttachments,
          isUploadingAttachment: false,
        ),
      );
    } on Failure catch (e) {
      emit(DailyReportFormFailure(e.message));
      emit(currentState.copyWith(isUploadingAttachment: false));
    } catch (e) {
      emit(DailyReportFormFailure(e.toString()));
      emit(currentState.copyWith(isUploadingAttachment: false));
    }
  }

  void removeAttachment(int index) {
    final currentState = state;
    if (currentState is! DailyReportFormReady) return;

    final updated = List<String>.from(currentState.attachmentPaths);
    if (index >= 0 && index < updated.length) {
      updated.removeAt(index);
      emit(currentState.copyWith(attachmentPaths: updated));
    }
  }

  Future<void> saveDraft() async {
    await _save(isDraft: true);
  }

  Future<void> submitForApproval() async {
    await _save(isDraft: false);
  }

  Future<void> _save({required bool isDraft}) async {
    final currentState = state;
    if (currentState is! DailyReportFormReady) return;

    if (currentState.dateError != null) {
      emit(DailyReportFormFailure(currentState.dateError!));
      emit(currentState);
      return;
    }

    if (currentState.tasks.trim().isEmpty) {
      emit(
        const DailyReportFormFailure(
          'Lütfen yapılan işler bölümünü doldurunuz.',
        ),
      );
      emit(currentState);
      return;
    }

    if (currentState.learnings.trim().isEmpty) {
      emit(
        const DailyReportFormFailure(
          'Lütfen öğrenilenler ve kazanımlar bölümünü doldurunuz.',
        ),
      );
      emit(currentState);
      return;
    }

    emit(
      DailyReportFormLoading(
        message: isDraft
            ? 'Taslak kaydediliyor...'
            : 'Rapor onaya gönderiliyor...',
      ),
    );

    try {
      final now = DateTime.now();
      final reportId =
          initialReport?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      final newStatus = isDraft ? ReportStatus.draft : ReportStatus.submitted;

      final report = DailyReportModel(
        id: reportId,
        internshipId: internshipId,
        studentId: studentId,
        workDate: currentState.workDate,
        tasks: currentState.tasks.trim(),
        learnings: currentState.learnings.trim(),
        hoursWorked: currentState.hoursWorked,
        attachmentPaths: currentState.attachmentPaths,
        status: newStatus,
        companyApproved: initialReport?.companyApproved ?? false,
        advisorApproved: initialReport?.advisorApproved ?? false,
        revisionComment: isDraft ? initialReport?.revisionComment : null,
        createdAt: initialReport?.createdAt ?? now,
        updatedAt: now,
        submittedAt: isDraft ? initialReport?.submittedAt : now,
      );

      if (initialReport == null) {
        await dailyReportRepository.createReport(report);
      } else {
        await dailyReportRepository.updateReport(report);
      }

      emit(
        DailyReportFormSuccess(
          message: isDraft
              ? 'Rapor taslak olarak kaydedildi.'
              : 'Rapor başarıyla onaya gönderildi.',
          wasSubmitted: !isDraft,
        ),
      );
    } on Failure catch (e) {
      emit(DailyReportFormFailure(e.message));
      emit(currentState);
    } catch (e) {
      emit(DailyReportFormFailure(e.toString()));
      emit(currentState);
    }
  }
}
