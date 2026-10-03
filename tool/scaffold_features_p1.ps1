# scaffold_features.ps1
# Generates placeholder files for all 8 Gmailoo features

function Write-DartFile($path, $content) {
  $dir = Split-Path $path -Parent
  if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  Set-Content -Path $path -Value $content.Trim() -Encoding UTF8
}

Write-Output "Scaffolding Feature 1: Auth..."
# 1. Auth Domain
Write-DartFile "lib/features/auth/domain/entities/auth_session.dart" @"
import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  final String userId;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const AuthSession({
    required this.userId,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [userId, email, displayName, photoUrl];
}
"@

Write-DartFile "lib/features/auth/domain/repositories/auth_repository.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSession>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, AuthSession?>> getCurrentSession();
}
"@

Write-DartFile "lib/features/auth/domain/usecases/sign_in_with_google.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle implements UseCase<AuthSession, NoParams> {
  final AuthRepository repository;
  const SignInWithGoogle(this.repository);

  @override
  Future<Either<Failure, AuthSession>> call(NoParams params) {
    return repository.signInWithGoogle();
  }
}
"@

Write-DartFile "lib/features/auth/domain/usecases/sign_out.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository repository;
  const SignOut(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.signOut();
  }
}
"@

Write-DartFile "lib/features/auth/domain/usecases/get_current_session.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class GetCurrentSession implements UseCase<AuthSession?, NoParams> {
  final AuthRepository repository;
  const GetCurrentSession(this.repository);

  @override
  Future<Either<Failure, AuthSession?>> call(NoParams params) {
    return repository.getCurrentSession();
  }
}
"@

# 1. Auth Data
Write-DartFile "lib/features/auth/data/models/auth_session_model.dart" @"
import '../../domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.userId,
    required super.email,
    super.displayName,
    super.photoUrl,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      userId: json['userId'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
  };
}
"@

Write-DartFile "lib/features/auth/data/datasources/auth_remote_data_source.dart" @"
import '../models/auth_session_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> signInWithGoogle();
  Future<void> signOut();
}
"@

Write-DartFile "lib/features/auth/data/datasources/auth_local_data_source.dart" @"
import '../models/auth_session_model.dart';

abstract class AuthLocalDataSource {
  Future<AuthSessionModel?> getSession();
  Future<void> saveSession(AuthSessionModel session);
  Future<void> clearSession();
}
"@

Write-DartFile "lib/features/auth/data/repositories/auth_repository_impl.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthSession>> signInWithGoogle() async {
    try {
      final session = await remoteDataSource.signInWithGoogle();
      await localDataSource.saveSession(session);
      return Right(session);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearSession();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSession?>> getCurrentSession() async {
    try {
      final session = await localDataSource.getSession();
      return Right(session);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
"@

# 1. Auth Presentation
Write-DartFile "lib/features/auth/presentation/cubit/auth_state.dart" @"
import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_session.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class Authenticated extends AuthState {
  final AuthSession session;
  const Authenticated(this.session);
  @override
  List<Object?> get props => [session];
}
class Unauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
"@

Write-DartFile "lib/features/auth/presentation/cubit/auth_cubit.dart" @"
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_current_session.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInWithGoogle signInWithGoogleUseCase;
  final SignOut signOutUseCase;
  final GetCurrentSession getCurrentSessionUseCase;

  AuthCubit({
    required this.signInWithGoogleUseCase,
    required this.signOutUseCase,
    required this.getCurrentSessionUseCase,
  }) : super(AuthInitial());

  Future<void> checkAuth() async {
    emit(AuthLoading());
    final result = await getCurrentSessionUseCase(const NoParams());
    result.fold(
      (failure) => emit(Unauthenticated()),
      (session) => session != null ? emit(Authenticated(session)) : emit(Unauthenticated()),
    );
  }

  Future<void> signIn() async {
    emit(AuthLoading());
    final result = await signInWithGoogleUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (session) => emit(Authenticated(session)),
    );
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    final result = await signOutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }
}
"@

Write-DartFile "lib/features/auth/presentation/pages/sign_in_page.dart" @"
import 'package:flutter/material.dart';
import '../widgets/google_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GoogleSignInButton(
          onPressed: () {},
        ),
      ),
    );
  }
}
"@

Write-DartFile "lib/features/auth/presentation/widgets/google_sign_in_button.dart" @"
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.login),
      label: const Text('Sign in with Google'),
    );
  }
}
"@

Write-Output "Scaffolding Feature 2: Weekly Cycle..."
# 2. Weekly Cycle Domain
Write-DartFile "lib/features/weekly_cycle/domain/entities/cycle_window.dart" @"
import 'package:equatable/equatable.dart';

class CycleWindow extends Equatable {
  final String cycleId;
  final DateTime startUtc;
  final DateTime endUtc;

  const CycleWindow({
    required this.cycleId,
    required this.startUtc,
    required this.endUtc,
  });

  @override
  List<Object?> get props => [cycleId, startUtc, endUtc];
}
"@

Write-DartFile "lib/features/weekly_cycle/domain/entities/cycle_status.dart" @"
import 'package:equatable/equatable.dart';
import 'cycle_window.dart';

class CycleStatus extends Equatable {
  final CycleWindow currentWindow;
  final bool isResetDay;

  const CycleStatus({
    required this.currentWindow,
    required this.isResetDay,
  });

  @override
  List<Object?> get props => [currentWindow, isResetDay];
}
"@

Write-DartFile "lib/features/weekly_cycle/domain/repositories/cycle_repository.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/cycle_status.dart';

abstract class CycleRepository {
  Future<Either<Failure, CycleStatus>> getCurrentCycleStatus();
  Future<Either<Failure, void>> executeWeeklyWipe();
}
"@

Write-DartFile "lib/features/weekly_cycle/domain/usecases/get_current_cycle_status.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cycle_status.dart';
import '../repositories/cycle_repository.dart';

class GetCurrentCycleStatus implements UseCase<CycleStatus, NoParams> {
  final CycleRepository repository;
  const GetCurrentCycleStatus(this.repository);

  @override
  Future<Either<Failure, CycleStatus>> call(NoParams params) {
    return repository.getCurrentCycleStatus();
  }
}
"@

Write-DartFile "lib/features/weekly_cycle/domain/usecases/execute_weekly_wipe.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cycle_repository.dart';

class ExecuteWeeklyWipe implements UseCase<void, NoParams> {
  final CycleRepository repository;
  const ExecuteWeeklyWipe(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.executeWeeklyWipe();
  }
}
"@

# 2. Weekly Cycle Data
Write-DartFile "lib/features/weekly_cycle/data/models/cycle_window_model.dart" @"
import '../../domain/entities/cycle_window.dart';

class CycleWindowModel extends CycleWindow {
  const CycleWindowModel({
    required super.cycleId,
    required super.startUtc,
    required super.endUtc,
  });
}
"@

Write-DartFile "lib/features/weekly_cycle/data/datasources/cycle_local_data_source.dart" @"
import '../models/cycle_window_model.dart';

abstract class CycleLocalDataSource {
  Future<CycleWindowModel> getCurrentWindow();
  Future<void> wipeCycleDatabase();
}
"@

Write-DartFile "lib/features/weekly_cycle/data/repositories/cycle_repository_impl.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cycle_status.dart';
import '../../domain/repositories/cycle_repository.dart';
import '../datasources/cycle_local_data_source.dart';

class CycleRepositoryImpl implements CycleRepository {
  final CycleLocalDataSource localDataSource;

  const CycleRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, CycleStatus>> getCurrentCycleStatus() async {
    try {
      final window = await localDataSource.getCurrentWindow();
      return Right(CycleStatus(currentWindow: window, isResetDay: false));
    } catch (e) {
      return Left(CycleFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> executeWeeklyWipe() async {
    try {
      await localDataSource.wipeCycleDatabase();
      return const Right(null);
    } catch (e) {
      return Left(CycleFailure(e.toString()));
    }
  }
}
"@

# 2. Weekly Cycle Presentation
Write-DartFile "lib/features/weekly_cycle/presentation/cubit/weekly_cycle_state.dart" @"
import 'package:equatable/equatable.dart';
import '../../domain/entities/cycle_status.dart';

abstract class WeeklyCycleState extends Equatable {
  const WeeklyCycleState();
  @override
  List<Object?> get props => [];
}

class WeeklyCycleInitial extends WeeklyCycleState {}
class WeeklyCycleLoading extends WeeklyCycleState {}
class WeeklyCycleLoaded extends WeeklyCycleState {
  final CycleStatus status;
  const WeeklyCycleLoaded(this.status);
  @override
  List<Object?> get props => [status];
}
class WeeklyCycleWiped extends WeeklyCycleState {}
class WeeklyCycleError extends WeeklyCycleState {
  final String message;
  const WeeklyCycleError(this.message);
  @override
  List<Object?> get props => [message];
}
"@

Write-DartFile "lib/features/weekly_cycle/presentation/cubit/weekly_cycle_cubit.dart" @"
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/execute_weekly_wipe.dart';
import '../../domain/usecases/get_current_cycle_status.dart';
import 'weekly_cycle_state.dart';

class WeeklyCycleCubit extends Cubit<WeeklyCycleState> {
  final GetCurrentCycleStatus getCycleStatusUseCase;
  final ExecuteWeeklyWipe executeWipeUseCase;

  WeeklyCycleCubit({
    required this.getCycleStatusUseCase,
    required this.executeWipeUseCase,
  }) : super(WeeklyCycleInitial());

  Future<void> loadCycleStatus() async {
    emit(WeeklyCycleLoading());
    final result = await getCycleStatusUseCase(const NoParams());
    result.fold(
      (f) => emit(WeeklyCycleError(f.message)),
      (status) => emit(WeeklyCycleLoaded(status)),
    );
  }

  Future<void> wipeCycle() async {
    emit(WeeklyCycleLoading());
    final result = await executeWipeUseCase(const NoParams());
    result.fold(
      (f) => emit(WeeklyCycleError(f.message)),
      (_) => emit(WeeklyCycleWiped()),
    );
  }
}
"@

Write-DartFile "lib/features/weekly_cycle/presentation/pages/zen_day_page.dart" @"
import 'package:flutter/material.dart';

class ZenDayPage extends StatelessWidget {
  const ZenDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Friday Zen Day - Relax and recharge.'),
      ),
    );
  }
}
"@

Write-DartFile "lib/features/weekly_cycle/presentation/widgets/cycle_progress_banner.dart" @"
import 'package:flutter/material.dart';

class CycleProgressBanner extends StatelessWidget {
  final String cycleId;
  const CycleProgressBanner({super.key, required this.cycleId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text('Cycle: \$cycleId'),
    );
  }
}
"@

Write-Output "Weekly Cycle scaffolded."
