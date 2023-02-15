import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:routemaster/routemaster.dart';

import '../repository/auth_repository.dart';
import '../utils/colors.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final navigator = Routemaster.of(context);

    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();

    if (errorModel.message != null) {
      Fluttertoast.showToast(msg: errorModel.message!);
    } else {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.push("/");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
            onPressed: () {
              signInWithGoogle(ref, context);
            },
            icon: Image.asset(
              "assets/images/google-logo.png",
              height: 22.0,
            ),
            label: const Text("Sign In With Google"),
            style: ElevatedButton.styleFrom(
              foregroundColor: kBlackColor,
              backgroundColor: kWhiteColor,
              minimumSize: const Size(250.0, 50.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            )),
      ),
    );
  }
}
