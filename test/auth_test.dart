import 'package:notetaker/services/auth/auth_exceptions.dart';
import 'package:notetaker/services/auth/auth_provider.dart';
import 'package:notetaker/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    // Make an instance of mockProvider
    final provider = MockAuthProvider();
    test('Should Not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot Log out if not Initialized', () {
      provider.logOut();
      throwsA(const TypeMatcher<NotinitilizedException>());
    });
    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null if initialized', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to synchronise in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 1)),
    );
  });
}

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
    //checks to make sure you are initialized else throw Exception
    if (!isInitialized) throw NotinitilizedException();

    if (email == 'foobar@gmail.com') throw UserNotFoundAuthException();

    if (password == 'foobar') throw WrongPasswordAuthException();
    // creat a user and initialise as false
    const user = AuthUser(isEmailVerified: false);

    _user = user;

    return Future.value();
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotinitilizedException();

    if (_user == null) throw UserNotFoundAuthException();

    await Future.delayed(const Duration(seconds: 1));

    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotinitilizedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }

  @override
  Future<void> initialize() async {
    //Fake making an API call i.e firebase in this case
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }
}
