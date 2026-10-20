import 'package:flutter/foundation.dart';

import 'user_role.dart';

/// Yörünge platformundaki kullanıcı profilini temsil eden değişmez (immutable) veri modeli.
/// Bu model beş farklı kullanıcı rolünü ve onay durumunu barındırır.
@immutable
class UserModel {
  final String id;
  final String adSoyad;
  final String email;
  final UserRole rol;
  final bool isApproved;
  final bool isDemo;
  final DateTime olusturulmaTarihi;

  const UserModel({
    required this.id,
    required this.adSoyad,
    required this.email,
    this.rol = UserRole.entrepreneur,
    this.isApproved = true,
    this.isDemo = true,
    required this.olusturulmaTarihi,
  });

  /// SharedPreferences veya yerel depolama için JSON serileştirme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adSoyad': adSoyad,
      'email': email,
      'rol': rol.name,
      'isApproved': isApproved,
      'isDemo': isDemo,
      'olusturulmaTarihi': olusturulmaTarihi.toIso8601String(),
    };
  }

  /// JSON verisinden UserModel nesnesi türetme
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ??
          'usr_${DateTime.now().millisecondsSinceEpoch}',
      adSoyad: json['adSoyad'] as String? ?? 'Girişimci',
      email: json['email'] as String? ?? 'demo@yorunge.app',
      rol: UserRole.fromString(json['rol'] as String?),
      isApproved: json['isApproved'] as bool? ?? true,
      isDemo: json['isDemo'] as bool? ?? true,
      olusturulmaTarihi: json['olusturulmaTarihi'] != null
          ? DateTime.tryParse(json['olusturulmaTarihi'] as String) ??
              DateTime.now()
          : DateTime.now(),
    );
  }

  UserModel copyWith({
    String? id,
    String? adSoyad,
    String? email,
    UserRole? rol,
    bool? isApproved,
    bool? isDemo,
    DateTime? olusturulmaTarihi,
  }) {
    return UserModel(
      id: id ?? this.id,
      adSoyad: adSoyad ?? this.adSoyad,
      email: email ?? this.email,
      rol: rol ?? this.rol,
      isApproved: isApproved ?? this.isApproved,
      isDemo: isDemo ?? this.isDemo,
      olusturulmaTarihi: olusturulmaTarihi ?? this.olusturulmaTarihi,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.adSoyad == adSoyad &&
        other.email == email &&
        other.rol == rol &&
        other.isApproved == isApproved &&
        other.isDemo == isDemo;
  }

  @override
  int get hashCode => Object.hash(id, adSoyad, email, rol, isApproved, isDemo);

  @override
  String toString() =>
      'UserModel(id: $id, adSoyad: $adSoyad, email: $email, rol: ${rol.displayName}, isApproved: $isApproved)';
}
