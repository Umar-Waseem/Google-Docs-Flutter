import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_docs_clone/constants.dart';
import 'package:google_docs_clone/extensions.dart';
import 'package:google_docs_clone/models/error_model.dart';
import 'package:google_docs_clone/models/user_model.dart';
import 'package:google_docs_clone/repository/local_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (_) {
    return AuthRepository(
      googleSignIn: GoogleSignIn(),
      client: Client(),
      localStorageRepository: LocalStorageRepository(),
    );
  },
);

final userProvider = StateProvider<UserModel?>(
  (ref) => null,
);

class AuthRepository {
  final GoogleSignIn googleSignIn;
  final Client client;
  final LocalStorageRepository localStorageRepository;

  AuthRepository({
    required this.googleSignIn,
    required this.client,
    required this.localStorageRepository,
  });

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel errorModel = ErrorModel(
      message: "Some unexpected error occured",
      data: null,
    );
    "Sign in with google".logInfo();
    try {
      final user = await googleSignIn.signIn();

      if (user != null) {
        final userModel = UserModel(
          email: user.email,
          name: user.displayName ?? "",
          profilePic: user.photoUrl ?? "",
          uid: "",
          token: "",
        );

        Map<String, String> headers = {
          "Content-Type": "application/json; charset=UTF-8",
        };

        var response = await client.post(
          Uri.parse("$host/signup"),
          body: userModel.toJson(),
          headers: headers,
        );

        var decodedResponse = jsonDecode(response.body);

        switch (response.statusCode) {
          case 200:
            final newUser = userModel.copyWith(
              uid: decodedResponse["user"]["_id"],
              token: decodedResponse["token"],
            );
            errorModel = ErrorModel(message: null, data: newUser);
            localStorageRepository.setToken(newUser.token);
            Fluttertoast.showToast(
                msg: "Signup Successful", timeInSecForIosWeb: 6);
            break;
          case 400:
            Fluttertoast.showToast(msg: response.statusCode.toString());
            break;
          default:
            Fluttertoast.showToast(msg: "Something went wrong");
            break;
        }
      } else {
        "User is null".logError();
        Fluttertoast.showToast(msg: "User is null", timeInSecForIosWeb: 6);
      }
    } catch (e) {
      e.toString().logError();
      Fluttertoast.showToast(msg: e.toString());
    }
    return errorModel;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(
      message: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await localStorageRepository.getToken();
      if (token != null) {
        Map<String, String> headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        };
        var response = await client.get(
          Uri.parse('$host/get-data'),
          headers: headers,
        );

        switch (response.statusCode) {
          case 200:
            final newUser = UserModel.fromJson(
              jsonEncode(jsonDecode(response.body)["user"]),
            ).copyWith(token: token);
            error = ErrorModel(message: null, data: newUser);
            localStorageRepository.setToken(newUser.token);
            break;
          default:
            Fluttertoast.showToast(msg: "Something went wrong");
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        message: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    localStorageRepository.setToken("");
  }
}
