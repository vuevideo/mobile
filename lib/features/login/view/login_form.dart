import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/features.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listener: (BuildContext buildContext, LoginState loginState) {
            if (loginState.status.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      loginState.errorMessage ??
                          'Something went wrong when logging into your account.',
                    ),
                  ),
                );

              context.read<LoginCubit>().acknowledgeError();
            }
          },
        ),
        BlocListener<AppBloc, AppState>(
          listener: (BuildContext buildContext, AppState appState) {
            if (appState.appStatus == AppStatus.Authenticated) {
              context.goNamed(HomePage.routeName);
            }
          },
        ),
      ],
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _EmailInput(),
            const SizedBox(height: 8),
            const _PasswordInput(),
            const SizedBox(height: 8),
            _LoginButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (BuildContext buildContext, LoginState loginState) {
        return TextField(
          key: const Key('loginForm_email_textfield'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            helperText: '',
            errorText:
                loginState.email.displayError != null ? 'Invalid Email' : null,
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (BuildContext buildContext, LoginState loginState) {
        return TextField(
          key: const Key('loginForm_password_textfield'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          keyboardType: TextInputType.text,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            helperText: '',
            errorText: loginState.password.displayError != null
                ? 'Invalid Password'
                : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: state.isValid
                    ? context.read<LoginCubit>().loginWithEmailAndPassword
                    : null,
                child: const Text('LOGIN'),
              );
      },
    );
  }
}
