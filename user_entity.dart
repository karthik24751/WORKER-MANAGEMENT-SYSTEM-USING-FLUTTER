import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? phoneNumber;
  final String? profileImageUrl;
  final bool isEmailVerified;
  final bool isActive;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phoneNumber,
    this.profileImageUrl,
    this.isEmailVerified = false,
    this.isActive = true,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  // Factory constructor for creating a new user
  factory UserEntity.create({
    required String id,
    required String email,
    required String name,
    required String role,
    String? phoneNumber,
    String? profileImageUrl,
    bool isEmailVerified = false,
    bool isActive = true,
    DateTime? lastLoginAt,
    Map<String, dynamic>? metadata,
  }) {
    final now = DateTime.now();
    return UserEntity(
      id: id,
      email: email,
      name: name,
      role: role,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      isEmailVerified: isEmailVerified,
      isActive: isActive,
      lastLoginAt: lastLoginAt,
      createdAt: now,
      updatedAt: now,
      metadata: metadata,
    );
  }

  // Copy with method for immutability
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? phoneNumber,
    String? profileImageUrl,
    bool? isEmailVerified,
    bool? isActive,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        role,
        phoneNumber,
        profileImageUrl,
        isEmailVerified,
        isActive,
        lastLoginAt,
        createdAt,
        updatedAt,
        metadata,
      ];

  // Helper methods
  bool get isWorker => role.toLowerCase() == 'worker';
  bool get isManager => role.toLowerCase() == 'manager';
  bool get isGeneralUser => role.toLowerCase() == 'user';
  
  String get displayName => name.isNotEmpty ? name : email.split('@').first;
  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts.first[0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name, role: $role)';
  }
}
