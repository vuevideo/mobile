part of 'register_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

final class RegisterState extends Equatable {
  final Name name;
  final UserName userName;
  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  const RegisterState({
    this.name = const Name.pure(),
    this.userName = const UserName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    Name? name,
    UserName? userName,
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return RegisterState(
      name: name ?? this.name,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        name,
        userName,
        email,
        password,
        status,
        isValid,
        errorMessage,
      ];
}
