import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<AppUser> login({required String email, required String password}) {
    return _datasource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _datasource.createUserWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() {
    return _datasource.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() {
    return _datasource.getCurrentUser();
  }
}
