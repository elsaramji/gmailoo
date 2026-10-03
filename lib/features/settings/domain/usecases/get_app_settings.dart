import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class GetAppSettings implements UseCase<AppSettings, NoParams> {
  final SettingsRepository repository;
  const GetAppSettings(this.repository);

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) {
    return repository.getSettings();
  }
}
