import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/vip_sender.dart';
import '../repositories/vip_repository.dart';

class AddVipSender implements UseCase<void, VipSender> {
  final VipRepository repository;
  const AddVipSender(this.repository);

  @override
  Future<Either<Failure, void>> call(VipSender params) {
    return repository.addVipSender(params);
  }
}
