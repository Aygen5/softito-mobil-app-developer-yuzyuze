import '../models/user_role.dart';

/// Yörünge platformundaki merkezi yetki kontrol servisi.
/// Tüm modüllerdeki izin kurallarını tek bir kaynaktan yönetir.
/// Dağınık `if` kontrollerini engeller ve iş kurallarını garanti eder.
abstract final class PermissionService {
  /// Mentorluk talebi gönderme yetkisi: Yalnızca Girişimci ve Admin.
  static bool canSendMentorshipRequest(UserRole role) {
    return role == UserRole.entrepreneur || role == UserRole.admin;
  }

  /// Yatırımcıya iletişim talebi gönderme: Yalnızca Girişimci ve Admin.
  static bool canSendInvestmentRequest(UserRole role) {
    return role == UserRole.entrepreneur || role == UserRole.admin;
  }

  /// Yeni iş planı oluşturma / düzenleme (Analiz): Yalnızca Girişimci ve Admin.
  static bool canCreateBusinessPlan(UserRole role) {
    return role == UserRole.entrepreneur || role == UserRole.admin;
  }

  /// Kendi fikir ve şirketleşme durumunu yönetme: Yalnızca Girişimci ve Admin.
  static bool canViewIdeaStatus(UserRole role) {
    return role == UserRole.entrepreneur || role == UserRole.admin;
  }

  /// Başvuru durumunu takip etme: Girişimci, Kurum Temsilcisi ve Admin.
  static bool canTrackApplications(UserRole role) {
    return role == UserRole.entrepreneur ||
        role == UserRole.programProvider ||
        role == UserRole.admin;
  }

  /// Destek programlarını yönetme (ekleme, durum güncelleme): Kurum Temsilcisi ve Admin.
  static bool canManagePrograms(UserRole role) {
    return role == UserRole.programProvider || role == UserRole.admin;
  }

  /// Topluluk akışında paylaşım yapma: Onaylı Girişimci veya Admin.
  static bool canPostInCommunity(UserRole role, {required bool isApproved}) {
    if (role == UserRole.admin) return true;
    if (role == UserRole.entrepreneur) return isApproved;
    return false;
  }

  /// Topluluk gönderilerini beğenme veya yanıtlama: Onaylı Girişimci veya Admin.
  static bool canInteractInCommunity(UserRole role,
      {required bool isApproved}) {
    if (role == UserRole.admin) return true;
    if (role == UserRole.entrepreneur) return isApproved;
    return false;
  }

  /// Mentor profilini düzenleme: Mentor ve Admin.
  static bool canEditMentorProfile(UserRole role) {
    return role == UserRole.mentor || role == UserRole.admin;
  }

  /// Yatırımcı profilini düzenleme: Yatırımcı ve Admin.
  static bool canEditInvestorProfile(UserRole role) {
    return role == UserRole.investor || role == UserRole.admin;
  }

  /// Kurum / Destek programı profilini düzenleme: Kurum Temsilcisi ve Admin.
  static bool canEditProgramProviderProfile(UserRole role) {
    return role == UserRole.programProvider || role == UserRole.admin;
  }

  /// Kullanıcıları ve rolleri yönetme: Yalnızca Platform Yöneticisi (Admin).
  static bool canManageUsers(UserRole role) {
    return role == UserRole.admin;
  }

  /// Girişimleri keşfetme: Tüm roller için izinlidir.
  static bool canDiscoverStartups(UserRole role) => true;

  /// Girişim bilgilerini değerlendirme ve kaydetme: Tüm roller için izinlidir.
  static bool canEvaluateStartups(UserRole role) => true;

  /// İşlem için izin verilmediğinde kullanıcıya gösterilecek Türkçe açıklayıcı mesaj
  static String getDenialReason(String actionKey) {
    switch (actionKey) {
      case 'mentorship_request':
        return 'Mentorluk eşleşme talebi yalnızca girişimciler ve platform yöneticisi tarafından gönderilebilir.';
      case 'investment_request':
        return 'Yatırımcı iletişim talebi yalnızca girişimciler ve platform yöneticisi tarafından gönderilebilir.';
      case 'business_plan':
      case 'create_business_plan':
        return 'Yeni iş planı hazırlama ve analiz testi yalnızca girişimci hesapları ve platform yöneticisi için kullanılabilir.';
      case 'idea_status':
      case 'view_idea_status':
        return 'Şirketleşme ve fikir yol haritası yalnızca girişimciler ve platform yöneticisi tarafından yönetilebilir.';
      case 'community_post':
        return 'Toplulukta paylaşım yapmak için girişimci hesabınızın onaylanmış olması veya yönetici yetkisi gerekir.';
      case 'community_interact':
        return 'Topluluk gönderilerini beğenmek veya yanıtlamak için onaylı girişimci hesabı gerekir.';
      case 'program_management':
      case 'manage_programs':
        return 'Destek programı yönetimi yalnızca kurum temsilcileri ve platform yöneticilerine açıktır.';
      case 'user_management':
        return 'Kullanıcı ve rol yönetimi için platform yöneticisi (Admin) yetkisi gereklidir.';
      default:
        return 'Bu işlem için mevcut rolünüzün yetkisi bulunmamaktadır.';
    }
  }
}
