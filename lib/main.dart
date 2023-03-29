import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notetaker/firebase_options.dart';
import 'package:notetaker/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.lightGreen,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: FutureBuilder(
          // initialize firebase before other calls to firebase
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                // final user = FirebaseAuth.instance.currentUser;

                // if (user?.emailVerified ?? false) {
                //   return const Text("Done");

                //   print("You are verified");
                // } else {
                //   return const EmailVerificationView();
                // }
                return const LoginView();
              default:
                return const Text("Loading....");
            }
          }),
    );
  }
}

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Please verify your email address"),
        TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              print(user);
              await user?.sendEmailVerification();
            },
            child: const Text("Send Email Verification"))
      ],
    );
  }
}
