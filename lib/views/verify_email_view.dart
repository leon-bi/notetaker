import 'package:flutter/material.dart';

import 'package:notetaker/constants/routes.dart';
import 'package:notetaker/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('verify email'),
      ),
      body: Column(
        children: [
          const Text(
              "we've sent you an email verification. Please open it and verify your account"),
          const Text(
              "If you haven't recieved the verification emeil yet please press the Button below"),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();

                if (mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                }
              },
              child: const Text("Send Email Verification")),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                if (mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                }
              },
              child: const Text('Restart'))
        ],
      ),
    );
  }
}
