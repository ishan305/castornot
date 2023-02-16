import 'package:castonaut/views/home_screen.dart';
import 'package:castonaut/views/login_screen.dart';
import 'package:castonaut/views/signup_screen.dart';
import 'package:castonaut/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const CastOrNot());
}

class CastOrNot extends StatelessWidget {
  const CastOrNot({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CastOrNot',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
        primaryColor: Colors.white,
      ),
      initialRoute: 'welcome_screen',
      routes: {
        'welcome_screen': (context) => const WelcomeScreen(),
        'signup_screen': (context) => const SignupScreen(),
        'login_screen': (context) => const LoginScreen(),
        'home_screen': (context) => const MyAppHomePage()
      },
    );
  }
}