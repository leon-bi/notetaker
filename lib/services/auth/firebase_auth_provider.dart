import 'package:firebase_core/firebase_core.dart';
import 'package:notetaker/firebase_options.dart';
import 'package:notetaker/services/auth/auth_provider.dart';
import 'package:notetaker/services/auth/auth_user.dart';
import 'package:notetaker/services/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == "weak-password") {
        throw WeakPasswordAuthException();
      } else if (e.code == "invalid-email") {
        InvalidEmailAuthException();
      }
      throw GenericAuthException();
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw UserNotFoundAuthException(); // devtools.log("user-not-found");
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() {
    // create a variable and assign the instance of current user
    final user = FirebaseAuth.instance.currentUser;
    // check if the user is not null
    if (user != null) {
      FirebaseAuth.instance.signOut();
    }
    // else log with the auth exception suitable
    throw UserNotLoggedInAuthException();
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
    throw UserNotLoggedInAuthException();
  }
  
  @override
  Future<void> initialize() async {
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
}
