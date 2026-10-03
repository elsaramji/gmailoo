import '../models/auth_session_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> signInWithGoogle();
  Future<void> signOut();
}
