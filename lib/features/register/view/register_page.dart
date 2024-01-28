import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/register/register.dart';

class RegisterPage extends StatefulWidget {

  static String routeName = "register_page";
  static String routePath = "/register";

  const RegisterPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: RegisterPage());

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register for new account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider<RegisterCubit>(
          create: (_) => RegisterCubit(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
          child: const RegisterForm(),
        ),
      ),
    );
  }
}
