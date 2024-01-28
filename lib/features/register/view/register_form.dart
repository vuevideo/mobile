import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:mobile/features/register/register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (BuildContext buildContext, RegisterState registerState) {
        if (registerState.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  registerState.errorMessage ??
                      'Something went wrong when creating your account.',
                ),
              ),
            );

          context.read<RegisterCubit>().acknowledgeError();
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _NameInput(),
            const SizedBox(height: 8),
            const _UserNameInput(),
            const SizedBox(height: 8),
            const _EmailInput(),
            const SizedBox(height: 8),
            const _PasswordInput(),
            const SizedBox(height: 8),
            _RegisterButton(),
          ],
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (BuildContext buildContext, RegisterState registerState) {
        return TextField(
          key: const Key('registerForm_name_textfield'),
          onChanged: (name) => context.read<RegisterCubit>().nameChanged(name),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Name',
            helperText: '',
            errorText:
                registerState.name.displayError != null ? 'Invalid Name' : null,
          ),
        );
      },
    );
  }
}

class _UserNameInput extends StatelessWidget {
  const _UserNameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.userName != current.userName,
      builder: (BuildContext buildContext, RegisterState registerState) {
        return TextField(
          key: const Key('registerForm_username_textfield'),
          onChanged: (userName) =>
              context.read<RegisterCubit>().userNameChanged(userName),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'User Name',
            helperText: '',
            errorText: registerState.userName.displayError != null
                ? 'Invalid User Name'
                : null,
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (BuildContext buildContext, RegisterState registerState) {
        return TextField(
          key: const Key('registerForm_email_textfield'),
          onChanged: (email) =>
              context.read<RegisterCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            helperText: '',
            errorText: registerState.email.displayError != null
                ? 'Invalid Email'
                : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (BuildContext buildContext, RegisterState registerState) {
        return TextField(
          key: const Key('registerForm_password_textfield'),
          onChanged: (password) =>
              context.read<RegisterCubit>().passwordChanged(password),
          keyboardType: TextInputType.text,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            helperText: '',
            errorText: registerState.password.displayError != null
                ? 'Invalid Password'
                : null,
          ),
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signUpForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.orangeAccent,
                ),
                onPressed: state.isValid
                    ? () => context
                        .read<RegisterCubit>()
                        .registerWithEmailAddressAndPassword()
                    : null,
                child: const Text('REGISTER'),
              );
      },
    );
  }
}
