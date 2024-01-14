import 'package:formz/formz.dart';

/// Name Validation Error
enum NameValidationError {
  /// Generic invalid error.
  invalid
}

/// Form input for an Name input.
class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');

  const Name.dirty([super.value = '']) : super.dirty();

  static final RegExp _NameRegExp = RegExp(
    r"^[a-z ,.'-]+$",
  );

  @override
  NameValidationError? validator(String? value) {
    return _NameRegExp.hasMatch(value ?? '')
        ? null
        : NameValidationError.invalid;
  }
}
