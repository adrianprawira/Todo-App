import 'package:firebase_auth/firebase_auth.dart';

import '../../model/authentication/authentication_detail.dart';

import '../providers/authentication_firebase_provider.dart';
import '../providers/google_sign_in_provider.dart';

class AuthenticationRepository {
  final AuthenticationFirebaseProvider? _authenticationFirebaseProvider;
  final GoogleSignInProvider? _googleSignInProvider;
  AuthenticationRepository(
      {AuthenticationFirebaseProvider? authenticationFirebaseProvider,
      GoogleSignInProvider? googleSignInProvider})
      : _googleSignInProvider = googleSignInProvider,
        _authenticationFirebaseProvider = authenticationFirebaseProvider;

  Stream<AuthenticationDetail> getAuthDetailStream() {
    return _authenticationFirebaseProvider!.getAuthStates().map((user) {
      return _getAuthCredentialFromFirebaseUser(user: user);
    });
  }

  Future<AuthenticationDetail> authenticateWithGoogle() async {
    User? user = await _authenticationFirebaseProvider!.login(
        credential: await _googleSignInProvider!.login());
    return _getAuthCredentialFromFirebaseUser(user: user);
  }

  Future<void> unAuthenticate() async {
    await _googleSignInProvider!.logout();
    await _authenticationFirebaseProvider!.logout();
  }

  AuthenticationDetail _getAuthCredentialFromFirebaseUser(
      {User? user}) {
    AuthenticationDetail authDetail;
    if (user != null) {
      authDetail = AuthenticationDetail(
        isValid: true,
        uid: user.uid,
        email: user.email,
        photoUrl: user.photoURL,
        name: user.displayName,
      );
    } else {
      authDetail = AuthenticationDetail(isValid: false);
    }
    return authDetail;
  }
}