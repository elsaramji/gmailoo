import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class UpdateAppSettings implements UseCase<void, AppSettings> {
  final SettingsRepository repository;
  const UpdateAppSettings(this.repository);

  @override
  Future<Either<Failure, void>> call(AppSettings params) {
    return repository.updateSettings(params);
  }
}
