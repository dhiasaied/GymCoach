import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    StorageService? storage,
    AuthService? authService,
  })  : _storage = storage ?? StorageService(),
        _authService = authService ?? AuthService();

  final StorageService _storage;
  final AuthService _authService;

  bool _isLoggedIn = false;
  bool _isLoading = true;
  UserProfile _profile = const UserProfile();

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  UserProfile get profile => _profile;

  Future<void> init() async {
    _isLoggedIn = await _storage.isLoggedIn();
    _profile = await _storage.loadProfile() ?? const UserProfile();
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    final result = await _authService.login(email, password);
    if (!result.isSuccess) return result.message;
    _isLoggedIn = true;
    _profile = result.profile!;
    await _storage.setLoggedIn(true);
    await _storage.saveProfile(_profile);
    notifyListeners();
    return null;
  }

  Future<String?> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final result = await _authService.register(
      fullName: fullName,
      email: email,
      password: password,
    );
    if (!result.isSuccess) return result.message;
    _isLoggedIn = true;
    _profile = result.profile!;
    await _storage.setLoggedIn(true);
    await _storage.saveProfile(_profile);
    notifyListeners();
    return null;
  }

  Future<String?> requestPasswordReset(String email) async {
    final result = await _authService.requestPasswordReset(email);
    return result.isSuccess ? null : result.message;
  }

  Future<String?> socialLogin(SocialProvider provider) async {
    final result = await _authService.socialLogin(provider);
    if (!result.isSuccess) return result.message;
    _isLoggedIn = true;
    _profile = result.profile!;
    await _storage.setLoggedIn(true);
    await _storage.saveProfile(_profile);
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    await _storage.setLoggedIn(false);
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile profile) async {
    _profile = profile;
    await _storage.saveProfile(profile);
    notifyListeners();
  }
}
