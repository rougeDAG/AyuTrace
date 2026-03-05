import '../entities/user.dart';

abstract class AuthRepository {
  Future<AppUser> login({required String email, required String password});
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}
