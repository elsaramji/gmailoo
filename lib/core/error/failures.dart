import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Local storage error occurred']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error']);
}

class CycleFailure extends Failure {
  const CycleFailure([super.message = 'Cycle boundary or wipe failure']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server response error']);
}
