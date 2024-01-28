import 'package:flutter/material.dart';
import 'package:mobile/features/login/login.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "login_page";
  static String routePath = "/login";

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to your account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
