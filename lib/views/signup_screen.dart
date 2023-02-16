// ignore_for_file: avoid_print

import 'package:castonaut/models/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>{
  UserInformation userInfo = UserInformation(id: '', name: '', email: '', password: '', birthday: DateTime.utc(275760,09,13));
  String passwordConfirm = '';
  bool showSpinner = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _onSignup() async {
    try{
      setState(() {
        showSpinner = true;
      });
      _validateFields(userInfo, passwordConfirm);
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: userInfo.email,
          password: userInfo.password);
      //TODO: make backend call to store user uuid and other info
      print(userCredential.toString());
      //TODO: Setup email confirmation from personal email
      Navigator.pushNamedAndRemoveUntil(context, 'home_screen', (route) => false);
    }
    catch(e){
      print(e);
    }
    setState(() {
      showSpinner = false;
    });
  }

  bool _validateFields(UserInformation userInfo, String passwordConfirm) {
    if (userInfo.name.isEmpty) {
      throw Exception('Name cannot be empty');
    }
    if (userInfo.email.isEmpty) {
      throw Exception('Email cannot be empty');
    }
    if (userInfo.password.isEmpty) {
      throw Exception('Password cannot be empty');
    }
    if (passwordConfirm.isEmpty) {
      throw Exception('Password confirmation cannot be empty');
    }
    if (userInfo.password != passwordConfirm) {
      throw Exception('Passwords do not match');
    }
    if (userInfo.birthday == DateTime.utc(275760,09,13)) {
      throw Exception('Birthday cannot be empty');
    }
    if (userInfo.birthday.isAfter(DateTime.now())) {
      throw Exception('Birthday cannot be in the future');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Name'),
            TextField(
              readOnly: showSpinner,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your name',
              ),
              onChanged: (value) {
                userInfo.name = value;
              },
            ),
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
                userInfo.email = value;
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
                userInfo.password = value;
              },
            ),
            const Text('Confirm Password'),
            TextField(
              readOnly: showSpinner,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Re-enter your password',
              ),
              onChanged: (value) {
                passwordConfirm = value;
              },
            ),
            const Text('Birthday'),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                onDateTimeChanged: (value) {
                  userInfo.birthday = value;
                },
                initialDateTime: DateTime.now().subtract(const Duration(days: 365*13)),
                mode: CupertinoDatePickerMode.date,
                maximumDate: DateTime.now()
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _onSignup();
              },
              child: showSpinner
                  ? const CircularProgressIndicator(semanticsLabel: 'Circular progress indicator')
                  : const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}