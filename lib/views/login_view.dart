import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:notetaker/constants/routes.dart';

import '../utilities/show_error_dialogue.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login View'),
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
          child: const Text("Login"),
          onPressed: () async {
            // Getting Text from the email and password _contollers
            // We then try the Email and Passowrd if true we access the passwords and username from #Firebase and also create an instance
            try {
              final email = _email.text;
              final password = _password.text;

              await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: password);

              // devtools.log(userCredential.toString());

              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
              }
            } on FirebaseAuthException catch (e) {
              if (e.code == "user-not-found") {
                await showErrorDialog(context, 'User-not-Found');
                // devtools.log("user-not-found");
              } else if (e.code == 'wrong-password') {
                await showErrorDialog(context, 'wrong-password');
              } else {
                await showErrorDialog(context, 'Error: ${e.code}');
              }
            } catch (e) {
              showErrorDialog(context, e.toString());
            }
          },
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text("Not registered? Register here"))
      ]),
    );
  }
}
