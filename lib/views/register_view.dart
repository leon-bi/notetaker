import 'package:flutter/material.dart';

import 'package:notetaker/constants/routes.dart';
import 'package:notetaker/services/auth/auth_exceptions.dart';
import 'package:notetaker/services/auth/auth_service.dart';

import '../utilities/show_error_dialogue.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register view'),
      ),
      body: Column(children: [
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          enableSuggestions: true,
          decoration: const InputDecoration(
            hintText: 'Enter your email here',
          ),
        ),
        TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here')),
        TextButton(
          child: const Text("Register"),
          onPressed: () async {
            // Getting Text from the email and password _contollers

            final email = _email.text;
            final password = _password.text;

            try {
              await AuthService.firebase().createUser(
                email: email,
                password: password,
              );
              AuthService.firebase().sendEmailVerification();
              if (mounted) {
                Navigator.of(context).pushNamed(verifyEmailRoute);
              }

              // devtools.log(userCredential.toString());
            } on EmailAlreadyInUseAuthException {
              await showErrorDialog(
                context,
                'Email-already-in-use',
              );
            } on WeakPasswordAuthException {
              await showErrorDialog(
                context,
                'Weak Passowrd',
              );
            } on InvalidEmailAuthException {
              await showErrorDialog(
                context,
                'This is an invalid Email',
              );
            } on GenericAuthException {
              await showErrorDialog(
                context,
                'Authentication Error',
              );
            }
          },
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Already registered? Login here"))
      ]),
    );
  }
}
