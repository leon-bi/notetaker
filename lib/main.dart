import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notetaker/firebase_options.dart';
import 'package:notetaker/views/login_view.dart';
import 'package:notetaker/views/register_view.dart';
import 'package:notetaker/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.lightGreen,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // initialize firebase before other calls to firebase
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                if (user.emailVerified) {
                  print("Email Verified");
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
              return const Text("Done");

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
