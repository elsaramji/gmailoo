import 'package:flutter/material.dart';
import '../widgets/google_sign_in_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GoogleSignInButton(
          onPressed: () {},
        ),
      ),
    );
  }
}
