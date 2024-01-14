import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:log/log.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthenticationRepository _authenticationRepository;

  RegisterCubit({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(
          const RegisterState(),
        );

  void nameChanged(String value) {
    final Name name = Name.dirty(value);

    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate(
          [
            name,
            state.userName,
            state.email,
            state.password,
          ],
        ),
      ),
    );
  }

  void userNameChanged(String value) {
    final UserName userName = UserName.dirty(value);

    emit(
      state.copyWith(
        userName: userName,
        isValid: Formz.validate(
          [
            state.name,
            userName,
            state.email,
            state.password,
          ],
        ),
      ),
    );
  }

  void emailChanged(String value) {
    final Email email = Email.dirty(value);

    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate(
          [
            state.name,
            state.userName,
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
            state.name,
            state.userName,
            state.email,
            password,
          ],
        ),
      ),
    );
  }

  Future<void> registerWithEmailAddressAndPassword() async {
    if (!state.isValid) {
      return;
    }

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
      ),
    );

    try {
      CreateAccountDto createAccountDto = CreateAccountDto(
        emailAddress: state.email.value,
        username: state.userName.value,
        password: state.password.value,
        name: state.name.value,
      );

      await _authenticationRepository.registerWithEmailAndPassword(
        createAccountDto: createAccountDto,
      );
    } on RegisterWithEmailAndPasswordFailure catch (error) {
      emit(
        state.copyWith(
          errorMessage: error.message,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
        ),
      );
      log.e(
        "RegisterCubit:registerWithEmailAddressAndPassword Error",
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
