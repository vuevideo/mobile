import 'package:bloc/bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:log/log.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState());

  void emailChanged(String value) {
    final Email email = Email.dirty(value);

    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate(
          [
            email,
            state.password,
          ],
        ),
      ),
    );
  }

  void passwordChanged(String value) {
    final Password password = Password.dirty(value);

    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate(
          [
            state.email,
            password,
          ],
        ),
      ),
    );
  }

  Future<void> loginWithEmailAndPassword() async {
    if (!state.isValid) {
      return;
    }

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
      ),
    );

    try {
      LoginAccountDto loginAccountDto = LoginAccountDto(
        emailAddress: state.email.value,
        password: state.password.value,
      );

      await _authenticationRepository.logInWithEmailAndPassword(
        loginAccountDto: loginAccountDto,
      );
    } on LogInWithEmailAndPasswordFailure catch (error) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (error, stackTrace) {
      log.e(
        "LoginCubit:loginWithEmailAndPassword Error",
        error: error,
        stackTrace: stackTrace,
      );

      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Something went wrong, please try again later.',
        ),
      );
    }
  }
}
