/// StajTakip rotalarının merkezi isimleri ve yolları.
abstract final class RouteNames {
  // Kimlik Doğrulama Rotaları
  static const login = '/login';
  static const loginName = 'login';

  static const register = '/register';
  static const registerName = 'register';

  static const forgotPassword = '/forgot-password';
  static const forgotPasswordName = 'forgotPassword';

  static const pendingApproval = '/pending-approval';
  static const pendingApprovalName = 'pendingApproval';

  // Öğrenci Rotaları (Shell ve Sekmeleri)
  static const studentHome = '/student/home';
  static const studentHomeName = 'studentHome';

  static const studentJournal = '/student/journal';
  static const studentJournalName = 'studentJournal';

  static const studentProgress = '/student/progress';
  static const studentProgressName = 'studentProgress';

  static const studentProfile = '/student/profile';
  static const studentProfileName = 'studentProfile';

  static const studentReportForm = '/student/journal/form';
  static const studentReportFormName = 'studentReportForm';

  // PDF Staj Defteri Ekranı (Ekran 6)
  static const studentPdfPreview = '/student/pdf-preview';
  static const studentPdfPreviewName = 'studentPdfPreview';

  // Şirket Yetkilisi Rotaları
  static const companyPending = '/company/pending';
  static const companyPendingName = 'companyPending';

  static const companyInterns = '/company/interns';
  static const companyInternsName = 'companyInterns';

  static const companyProfile = '/company/profile';
  static const companyProfileName = 'companyProfile';

  // Akademik Danışman Rotaları
  static const advisorPending = '/advisor/pending';
  static const advisorPendingName = 'advisorPending';

  static const advisorStudents = '/advisor/students';
  static const advisorStudentsName = 'advisorStudents';

  static const advisorProfile = '/advisor/profile';
  static const advisorProfileName = 'advisorProfile';

  // Ortak Onay Detay Rotası (Ekran 4)
  static const approvalDetail = '/approval/detail';
  static const approvalDetailName = 'approvalDetail';
}
