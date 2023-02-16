// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool showSpinner = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    try {
      setState(() {
        showSpinner = true;
      });
      final UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(user.toString());
      Navigator.pushNamedAndRemoveUntil(context, 'home_screen', (route) => false);
    } catch (e) {
      print(e);
    }
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //TODO: Add CastOrNot logo
            const Text('Email'),
            TextField(
              readOnly: showSpinner,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
              ),
              onChanged: (value) {
                email = value;
              },
            ),
            const Text('Password'),
            TextField(
              readOnly: showSpinner,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your password',
              ),
              onChanged: (value) {
                password = value;
              },
            ),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              child: showSpinner
                  ? const CircularProgressIndicator(semanticsLabel: 'Circular progress indicator')
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}