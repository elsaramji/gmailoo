import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/vip_sender.dart';
import '../repositories/vip_repository.dart';

class GetVipSenders implements UseCase<List<VipSender>, NoParams> {
  final VipRepository repository;
  const GetVipSenders(this.repository);

  @override
  Future<Either<Failure, List<VipSender>>> call(NoParams params) {
    return repository.getVipSenders();
  }
}
