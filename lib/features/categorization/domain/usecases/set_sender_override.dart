import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/sender_override.dart';
import '../repositories/categorization_repository.dart';

class SetSenderOverride implements UseCase<void, SenderOverride> {
  final CategorizationRepository repository;
  const SetSenderOverride(this.repository);

  @override
  Future<Either<Failure, void>> call(SenderOverride params) {
    return repository.setSenderOverride(params);
  }
}
