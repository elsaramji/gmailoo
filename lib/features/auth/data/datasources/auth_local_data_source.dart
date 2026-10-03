import '../models/auth_session_model.dart';

abstract class AuthLocalDataSource {
  Future<AuthSessionModel?> getSession();
  Future<void> saveSession(AuthSessionModel session);
  Future<void> clearSession();
}
