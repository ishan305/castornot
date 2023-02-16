import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to CastOrNot'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'login_screen');
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'signup_screen');
              },
              child: const Text('Sign up'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, 'home_screen', (route) => false);
              }, child: const Text('Continue')
            ),
          ],
        ),
      ),
    );
  }
}