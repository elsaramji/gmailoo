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
