import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/vip_sender.dart';
import '../../domain/repositories/vip_repository.dart';
import '../datasources/vip_local_data_source.dart';
import '../models/vip_sender_model.dart';

class VipRepositoryImpl implements VipRepository {
  final VipLocalDataSource localDataSource;
  const VipRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<VipSender>>> getVipSenders() async {
    try {
      final list = await localDataSource.getVipSenders();
      return Right(list);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addVipSender(VipSender sender) async {
    try {
      await localDataSource.insertVipSender(VipSenderModel(
        email: sender.email,
        displayName: sender.displayName,
        isMuted: sender.isMuted,
      ));
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeVipSender(String email) async {
    try {
      await localDataSource.deleteVipSender(email);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleVipMute(String email, bool isMuted) async {
    try {
      await localDataSource.updateMuteStatus(email, isMuted);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }
}
