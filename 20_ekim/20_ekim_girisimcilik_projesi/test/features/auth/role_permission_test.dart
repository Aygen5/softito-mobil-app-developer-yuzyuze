import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yorunge/features/analiz/controller/analiz_controller.dart';
import 'package:yorunge/features/auth/controller/auth_controller.dart';
import 'package:yorunge/features/auth/controller/permission_service.dart';
import 'package:yorunge/features/auth/data/auth_mock_data.dart';
import 'package:yorunge/features/auth/models/user_role.dart';
import 'package:yorunge/features/fikir_durumu/controller/fikir_durumu_controller.dart';
import 'package:yorunge/features/mentor/controller/mentor_controller.dart';
import 'package:yorunge/features/mentor/models/mentor_model.dart';
import 'package:yorunge/features/programlar/controller/programlar_controller.dart';
import 'package:yorunge/features/topluluk/controller/topluluk_controller.dart';
import 'package:yorunge/features/topluluk/models/topluluk_model.dart';
import 'package:yorunge/features/yatirimci/controller/yatirimci_controller.dart';

void main() {
  group('Yörünge Çok Rollü Yetkilendirme & Demo Kullanıcı Testleri', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    // 1. Beş rol doğru tanımlanmış
    test('1. Beş rol doğru tanımlanmış ve enum özellikleri eksiksizdir', () {
      expect(UserRole.values.length, equals(5));
      expect(UserRole.values, contains(UserRole.entrepreneur));
      expect(UserRole.values, contains(UserRole.investor));
      expect(UserRole.values, contains(UserRole.mentor));
      expect(UserRole.values, contains(UserRole.programProvider));
      expect(UserRole.values, contains(UserRole.admin));

      expect(UserRole.entrepreneur.displayName, equals('Girişimci'));
      expect(UserRole.investor.displayName, equals('Yatırımcı'));
      expect(UserRole.mentor.displayName, equals('Mentor'));
      expect(UserRole.programProvider.displayName, equals('Kurum Temsilcisi'));
      expect(UserRole.admin.displayName, equals('Platform Yöneticisi'));

      expect(
          UserRole.fromString('entrepreneur'), equals(UserRole.entrepreneur));
      expect(UserRole.fromString('investor'), equals(UserRole.investor));
      expect(UserRole.fromString('mentor'), equals(UserRole.mentor));
      expect(UserRole.fromString('programProvider'),
          equals(UserRole.programProvider));
      expect(UserRole.fromString('admin'), equals(UserRole.admin));
      expect(UserRole.fromString('bilinmeyen'), equals(UserRole.entrepreneur));
    });

    // 2. Girişimci izinli işlemleri yapabiliyor
    test('2. Girişimci izinli işlemleri yapabiliyor', () {
      const role = UserRole.entrepreneur;
      expect(PermissionService.canSendMentorshipRequest(role), isTrue);
      expect(PermissionService.canSendInvestmentRequest(role), isTrue);
      expect(PermissionService.canCreateBusinessPlan(role), isTrue);
      expect(PermissionService.canViewIdeaStatus(role), isTrue);
      expect(PermissionService.canTrackApplications(role), isTrue);
      expect(PermissionService.canDiscoverStartups(role), isTrue);
    });

    // 3. Onaysız girişimci toplulukta paylaşım yapamıyor
    test('3. Onaysız girişimci toplulukta paylaşım ve etkileşim yapamıyor', () {
      const role = UserRole.entrepreneur;
      expect(PermissionService.canPostInCommunity(role, isApproved: false),
          isFalse);
      expect(PermissionService.canInteractInCommunity(role, isApproved: false),
          isFalse);
    });

    // 4. Onaylı girişimci topluluk etkileşimi yapabiliyor
    test('4. Onaylı girişimci toplulukta paylaşım ve etkileşim yapabiliyor',
        () {
      const role = UserRole.entrepreneur;
      expect(
          PermissionService.canPostInCommunity(role, isApproved: true), isTrue);
      expect(PermissionService.canInteractInCommunity(role, isApproved: true),
          isTrue);
    });

    // 5. Yatırımcı yeni iş planı oluşturamıyor
    test('5. Yatırımcı yeni iş planı oluşturamıyor ve mentorluk isteyemiyor',
        () {
      const role = UserRole.investor;
      expect(PermissionService.canCreateBusinessPlan(role), isFalse);
      expect(PermissionService.canSendMentorshipRequest(role), isFalse);
      expect(PermissionService.canSendInvestmentRequest(role), isFalse);
      expect(PermissionService.canEditInvestorProfile(role), isTrue);
      expect(PermissionService.canDiscoverStartups(role), isTrue);
    });

    // 6. Mentor mentorluk talebi gönderemiyor
    test(
        '6. Mentor mentorluk talebi gönderemiyor fakat mentor profilini düzenleyebiliyor',
        () {
      const role = UserRole.mentor;
      expect(PermissionService.canSendMentorshipRequest(role), isFalse);
      expect(PermissionService.canSendInvestmentRequest(role), isFalse);
      expect(PermissionService.canCreateBusinessPlan(role), isFalse);
      expect(PermissionService.canEditMentorProfile(role), isTrue);
      expect(PermissionService.canDiscoverStartups(role), isTrue);
    });

    // 7. Kurum temsilcisi program yönetimi yetkisine sahip
    test('7. Kurum temsilcisi program yönetimi yetkisine sahip', () {
      const role = UserRole.programProvider;
      expect(PermissionService.canManagePrograms(role), isTrue);
      expect(PermissionService.canEditProgramProviderProfile(role), isTrue);
      expect(PermissionService.canTrackApplications(role), isTrue);
      expect(PermissionService.canCreateBusinessPlan(role), isFalse);
      expect(PermissionService.canSendMentorshipRequest(role), isFalse);
    });

    // 8. Admin platform yönetim yetkilerine sahip
    test('8. Admin yönetim yetkilerine ve tüm operasyonel izinlere sahip', () {
      const role = UserRole.admin;
      expect(PermissionService.canManageUsers(role), isTrue);
      expect(PermissionService.canManagePrograms(role), isTrue);
      expect(PermissionService.canCreateBusinessPlan(role), isTrue);
      expect(PermissionService.canSendMentorshipRequest(role), isTrue);
      expect(PermissionService.canSendInvestmentRequest(role), isTrue);
      expect(PermissionService.canPostInCommunity(role, isApproved: false),
          isTrue);
      expect(PermissionService.canInteractInCommunity(role, isApproved: false),
          isTrue);
    });

    // 9. Yetkisiz işlem controller seviyesinde engelleniyor
    test('9. Yetkisiz işlemler ilgili controller katmanlarında engelleniyor',
        () async {
      // MentorController: Yatırımcı mentorluk isteği gönderemez
      final mentorController = MentorController();
      final ilkMentorId = mentorController.tumMentorlar.value.first.id;
      final mentorReqResult = mentorController.eslesmeIste(
        ilkMentorId,
        currentRole: UserRole.investor,
      );
      expect(mentorReqResult, isFalse);
      expect(mentorController.tumMentorlar.value.first.durum,
          equals(EslesmeDurumu.yok));

      // Girişimci mentorluk isteyebilir
      final girisimciReqResult = mentorController.eslesmeIste(
        ilkMentorId,
        currentRole: UserRole.entrepreneur,
      );
      expect(girisimciReqResult, isTrue);
      expect(mentorController.tumMentorlar.value.first.durum,
          equals(EslesmeDurumu.beklemede));
      mentorController.dispose();

      // YatirimciController: Mentor yatırımcı iletişimi isteyemez
      final yatirimciController = YatirimciController();
      final ilkYatirimciId = yatirimciController.tumYatirimcilar.value.first.id;
      final yatirimReqResult = yatirimciController.iletisimTalebiGonder(
        ilkYatirimciId,
        currentRole: UserRole.mentor,
      );
      expect(yatirimReqResult, isFalse);
      expect(
          yatirimciController
              .tumYatirimcilar.value.first.iletisimTalebiGonderildi,
          isFalse);
      yatirimciController.dispose();

      // AnalizController: Yatırımcı iş planı gönderemez
      final analizController = AnalizController();
      final submitResult = await analizController.basvuruGonder(
        currentRole: UserRole.investor,
      );
      expect(submitResult, isFalse);
      expect(analizController.gonderildi.value, isFalse);
      analizController.dispose();

      // ProgramlarController: Girişimci program düzenleyemez
      final programlarController = ProgramlarController();
      final manageResult = programlarController.programDuzenle(
        'prg_1',
        currentRole: UserRole.entrepreneur,
      );
      expect(manageResult, isFalse);
      final adminManageResult = programlarController.programDuzenle(
        'prg_1',
        currentRole: UserRole.programProvider,
      );
      expect(adminManageResult, isTrue);
      programlarController.dispose();

      // ToplulukController: Yatırımcı veya onaysız girişimci gönderi ekleyemez
      final toplulukController = ToplulukController(
        baslangicDurumu: ToplulukKullaniciDurumu.onaysiz,
        baslangicRol: UserRole.entrepreneur,
      );
      expect(toplulukController.paylasabilir, isFalse);
      final postBlocked =
          toplulukController.gonderiEkle(metin: 'Onaysız deneme');
      expect(postBlocked, isFalse);

      toplulukController.rolAyarla(UserRole.investor);
      toplulukController.kullaniciDurumuAyarla(ToplulukKullaniciDurumu.onayli);
      expect(toplulukController.paylasabilir, isFalse);

      toplulukController.rolAyarla(UserRole.admin);
      expect(toplulukController.paylasabilir, isTrue);
      toplulukController.dispose();

      // FikirDurumuController: Yatırımcı şirketleşme adımını güncelleyemez
      final fikirController = FikirDurumuController();
      final ilkFikirId = fikirController.fikirler.value.first.id;
      final legalStepResult = fikirController.hukukiAdimIlerle(
        ilkFikirId,
        1,
        currentRole: UserRole.investor,
      );
      expect(legalStepResult, isFalse);
      fikirController.dispose();
    });

    // 10. Demo hesapları arasında geçişte eski rolün yetkileri kalmıyor
    test('10. Demo hesapları arasında geçişte eski rolün yetkileri kalmıyor',
        () async {
      final authController = AuthController();

      // Yatırımcı hesabı ile oturum aç
      final yatirimciUser = AuthMockData.tumDemoHesaplar.firstWhere(
        (u) => u.rol == UserRole.investor,
      );
      await authController.switchDemoAccount(yatirimciUser);

      expect(authController.currentRole, equals(UserRole.investor));
      expect(
          PermissionService.canCreateBusinessPlan(authController.currentRole!),
          isFalse);
      expect(
          PermissionService.canSendMentorshipRequest(
              authController.currentRole!),
          isFalse);

      // Onaylı Girişimci hesabına geçiş yap
      final girisimciUser = AuthMockData.tumDemoHesaplar.firstWhere(
        (u) => u.rol == UserRole.entrepreneur && u.isApproved,
      );
      await authController.switchDemoAccount(girisimciUser);

      expect(authController.currentRole, equals(UserRole.entrepreneur));
      expect(authController.isApproved, isTrue);
      expect(
          PermissionService.canCreateBusinessPlan(authController.currentRole!),
          isTrue);
      expect(
          PermissionService.canSendMentorshipRequest(
              authController.currentRole!),
          isTrue);
      expect(
          PermissionService.canPostInCommunity(authController.currentRole!,
              isApproved: authController.isApproved),
          isTrue);

      // Kurum temsilcisi hesabına geçiş yap
      final kurumUser = AuthMockData.tumDemoHesaplar.firstWhere(
        (u) => u.rol == UserRole.programProvider,
      );
      await authController.switchDemoAccount(kurumUser);

      expect(authController.currentRole, equals(UserRole.programProvider));
      // Kurum temsilcisi iş planı yapamaz ve mentorluk isteyemez (eski girişimci yetkileri silinmiştir)
      expect(
          PermissionService.canCreateBusinessPlan(authController.currentRole!),
          isFalse);
      expect(
          PermissionService.canSendMentorshipRequest(
              authController.currentRole!),
          isFalse);
      expect(PermissionService.canManagePrograms(authController.currentRole!),
          isTrue);

      // Çıkış yapıldığında oturum ve rol temizlenir
      await authController.logout();
      expect(authController.isAuthenticated, isFalse);
      expect(authController.currentRole, isNull);

      authController.dispose();
    });

    // 11. Yetki reddi mesajları pedagojik ve Türkçe döndürülüyor
    test('11. Yetki ret mesajları anlaşılır Türkçe açıklamalar içerir', () {
      final mentorReason =
          PermissionService.getDenialReason('mentorship_request');
      expect(mentorReason, contains('yalnızca girişimci'));

      final investReason =
          PermissionService.getDenialReason('investment_request');
      expect(investReason, contains('yalnızca girişimci'));

      final planReason =
          PermissionService.getDenialReason('create_business_plan');
      expect(planReason, contains('girişimci'));

      final commReason = PermissionService.getDenialReason('community_post');
      expect(commReason, contains('onay'));
    });
  });
}
