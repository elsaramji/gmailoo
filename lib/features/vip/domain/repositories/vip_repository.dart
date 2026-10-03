import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/vip_sender.dart';

abstract class VipRepository {
  Future<Either<Failure, List<VipSender>>> getVipSenders();
  Future<Either<Failure, void>> addVipSender(VipSender sender);
  Future<Either<Failure, void>> removeVipSender(String email);
  Future<Either<Failure, void>> toggleVipMute(String email, bool isMuted);
}
