import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/vip_repository.dart';

class RemoveVipSender implements UseCase<void, String> {
  final VipRepository repository;
  const RemoveVipSender(this.repository);

  @override
  Future<Either<Failure, void>> call(String email) {
    return repository.removeVipSender(email);
  }
}
