import '../models/user_profile.dart';
import 'storage_service.dart';

enum AuthFailure { invalidCredentials, emailTaken, emailNotFound, unknown }

class AuthResult {
  const AuthResult.success(this.profile)
      : failure = null,
        message = null;

  const AuthResult.failure(this.failure, this.message) : profile = null;

  final UserProfile? profile;
  final AuthFailure? failure;
  final String? message;

  bool get isSuccess => profile != null;
}

enum SocialProvider { google, apple }

class AuthService {
  AuthService({StorageService? storage}) : _storage = storage ?? StorageService();

  final StorageService _storage;

  Future<AuthResult> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final users = await _storage.loadUsers();

    if (users.containsKey(normalizedEmail)) {
      if (users[normalizedEmail] != password) {
        return const AuthResult.failure(
          AuthFailure.invalidCredentials,
          'Invalid email or password.',
        );
      }
      final profile = await _storage.loadProfile();
      if (profile != null && profile.email.toLowerCase() == normalizedEmail) {
        return AuthResult.success(profile);
      }
      return AuthResult.success(UserProfile(email: normalizedEmail));
    }

    // Accept any valid form credentials (email + password ≥ 6 chars, validated in UI).
    if (password.length >= 6) {
      final profile = UserProfile(email: normalizedEmail);
      await _storage.saveProfile(profile);
      return AuthResult.success(profile);
    }

    return const AuthResult.failure(
      AuthFailure.invalidCredentials,
      'Invalid email or password.',
    );
  }

  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final users = await _storage.loadUsers();

    if (users.containsKey(normalizedEmail)) {
      return const AuthResult.failure(
        AuthFailure.emailTaken,
        'An account with this email already exists.',
      );
    }

    users[normalizedEmail] = password;
    await _storage.saveUsers(users);

    final profile = UserProfile(
      fullName: fullName.trim(),
      email: normalizedEmail,
    );
    await _storage.saveProfile(profile);
    return AuthResult.success(profile);
  }

  Future<AuthResult> requestPasswordReset(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final users = await _storage.loadUsers();

    if (!users.containsKey(normalizedEmail) &&
        normalizedEmail != 'athlete@gymcoach.com') {
      return const AuthResult.failure(
        AuthFailure.emailNotFound,
        'No account found for this email.',
      );
    }
    return AuthResult.success(UserProfile(email: normalizedEmail));
  }

  Future<AuthResult> socialLogin(SocialProvider provider) async {
    final email = provider == SocialProvider.google
        ? 'google.user@gymcoach.com'
        : 'apple.user@gymcoach.com';
    final name = provider == SocialProvider.google ? 'Google Athlete' : 'Apple Athlete';

    final users = await _storage.loadUsers();
    if (!users.containsKey(email)) {
      users[email] = 'oauth_${provider.name}';
      await _storage.saveUsers(users);
    }

    final profile = UserProfile(fullName: name, email: email);
    await _storage.saveProfile(profile);
    return AuthResult.success(profile);
  }
}
