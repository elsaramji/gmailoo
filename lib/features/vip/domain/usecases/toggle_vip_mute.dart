import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/vip_repository.dart';

class ToggleVipMuteParams {
  final String email;
  final bool isMuted;
  const ToggleVipMuteParams({required this.email, required this.isMuted});
}

class ToggleVipMute implements UseCase<void, ToggleVipMuteParams> {
  final VipRepository repository;
  const ToggleVipMute(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleVipMuteParams params) {
    return repository.toggleVipMute(params.email, params.isMuted);
  }
}
