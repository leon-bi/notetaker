import 'package:notetaker/services/auth/auth_provider.dart';
import 'package:notetaker/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {}

class NotinitilizedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    //checks to make sure you are initialized else throw Exception
    if (!isInitialized) throw NotinitilizedException();
    //Fake making an API call i.e firebase in this case
    await Future.delayed(const Duration(seconds: 1));
    // calls login fuction to get auth user
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    // TODO: implement logIn
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() async {
    //Fake making an API call i.e firebase in this case
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }
}
