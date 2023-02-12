import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/auth_repository.dart';
import '../utils/colors.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(WidgetRef ref) {
    ref.read(authRepositoryProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
            onPressed: () => signInWithGoogle(ref),
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
