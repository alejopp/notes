import 'package:bext_notes/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final user = await authRepository.login(event.email, event.password);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthError("Correo o contraseña inválidos"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await authRepository.logout();
      emit(Unauthenticated());
    });

    on<CheckAuthStatus>((event, emit) async {
      await Future.delayed(const Duration(seconds: 2));
      final token = await authRepository.getCurrentToken();
      final user = await authRepository.getCurrentUser();
      if (token != null && token.isNotEmpty) {
        emit(Authenticated(user!));
      } else {
        emit(Unauthenticated());
      }
    });
  }
}
