import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class GetCurrentSession implements UseCase<AuthSession?, NoParams> {
  final AuthRepository repository;
  const GetCurrentSession(this.repository);

  @override
  Future<Either<Failure, AuthSession?>> call(NoParams params) {
    return repository.getCurrentSession();
  }
}
