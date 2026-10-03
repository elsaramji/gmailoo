import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSession>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, AuthSession?>> getCurrentSession();
}
