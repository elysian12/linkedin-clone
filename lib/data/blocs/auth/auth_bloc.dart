import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/auth/auth_repositories.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitialState()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(AuthLoadingState());
        var res = await _authRepository.loginWithGoogle();

        if (res.keys.contains('error')) {
          emit(AuthErrorState(error: res['error']));
        } else {
          emit(AuthenticatedState());
        }
      }
    });
  }
}
