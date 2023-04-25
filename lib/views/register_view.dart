import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:notetaker/constants/routes.dart';

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
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email, password: password);
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
              if (mounted) {
                Navigator.of(context).pushNamed(verifyEmailRoute);
              }

              // devtools.log(userCredential.toString());
            } on FirebaseException catch (e) {
              if (e.code == "email-already-in-use") {
                await showErrorDialog(context, 'Email-already-in-use');
              } else if (e.code == "weak-password") {
                await showErrorDialog(context, 'Weak Passowrd');
              } else if (e.code == "invalid-email") {
                await showErrorDialog(context, 'This is an invalid Email');
              } else {
                await showErrorDialog(context, 'Error ${e.code}');
              }
            } catch (e) {
              showErrorDialog(context, e.toString());
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
