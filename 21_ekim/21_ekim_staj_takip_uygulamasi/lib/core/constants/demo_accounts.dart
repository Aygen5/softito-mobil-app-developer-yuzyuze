import 'package:flutter/material.dart';

import '../../data/mock/mock_data.dart';
import '../../data/models/user_model.dart';
import '../theme/app_colors.dart';

/// Test ve jüri/öğretmen değerlendirmelerinde tek tıkla hızlı giriş yapmayı sağlayan demo hesap modeli.
class DemoAccount {
  final String title;
  final String roleLabel;
  final String email;
  final String password;
  final IconData icon;
  final Color color;
  final UserModel userModel;

  const DemoAccount({
    required this.title,
    required this.roleLabel,
    required this.email,
    required this.password,
    required this.icon,
    required this.color,
    required this.userModel,
  });
}

/// Uygulama için tanımlı hazır demo hesapları.
abstract final class DemoAccounts {
  static final student = DemoAccount(
    title: 'Öğrenci Girişi',
    roleLabel: 'Stajyer Paneli & Günlük Rapor',
    email: 'ogrenci@test.com',
    password: 'password123',
    icon: Icons.school_rounded,
    color: AppColors.primaryBlue,
    userModel: MockData.studentUser,
  );

  static final company = DemoAccount(
    title: 'Şirket Yetkilisi Girişi',
    roleLabel: 'Kurum Onay & Düzeltme Arayüzü',
    email: 'sirket@test.com',
    password: 'password123',
    icon: Icons.business_rounded,
    color: AppColors.accentTeal,
    userModel: MockData.companyUser,
  );

  static final advisor = DemoAccount(
    title: 'Akademik Danışman Girişi',
    roleLabel: 'Akademik Onay & Notlandırma',
    email: 'danisman@test.com',
    password: 'password123',
    icon: Icons.account_balance_rounded,
    color: AppColors.primaryNavy,
    userModel: MockData.advisorUser,
  );

  static final List<DemoAccount> all = [student, company, advisor];
}
