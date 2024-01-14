import 'package:formz/formz.dart';

/// UserName Validation Error
enum UserNameValidationError {
  /// Generic invalid error.
  invalid
}

/// Form input for an UserName input.
class UserName extends FormzInput<String, UserNameValidationError> {
  const UserName.pure() : super.pure('');

  const UserName.dirty([super.value = '']) : super.dirty();

  static final RegExp _UserNameRegExp = RegExp(
    r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$',
  );

  @override
  UserNameValidationError? validator(String? value) {
    return _UserNameRegExp.hasMatch(value ?? '')
        ? null
        : UserNameValidationError.invalid;
  }
}
