import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_docs_clone/utils/utilities.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (_) {
    return AuthRepository(googleSignIn: GoogleSignIn());
  },
);

class AuthRepository {
  final GoogleSignIn googleSignIn;

  AuthRepository({required this.googleSignIn});

  void signInWithGoogle() async {
    Util.logFootprint("Sign in with google");
    try {
      final user = await googleSignIn.signIn();

      if (user != null) {
        Util.logSuccess("Login Successful");

        Util.logInfo("User Email: ${user.email}");
        Util.logInfo("User Name: ${user.displayName}");
        Util.logInfo("User Photo: ${user.photoUrl}");

        Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        Util.logError("User is null");
        Fluttertoast.showToast(
            msg: "User is null", toastLength: Toast.LENGTH_LONG);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
