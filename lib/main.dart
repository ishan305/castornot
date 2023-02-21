import 'package:castonaut/utils/api_key.dart';
import 'package:castonaut/utils/api_secret.dart';
import 'package:castonaut/views/home_screen.dart';
import 'package:castonaut/views/login_screen.dart';
import 'package:castonaut/views/signup_screen.dart';
import 'package:castonaut/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.fetchAndActivate();

  await setApiKey(remoteConfig);
  await setApiSecret(remoteConfig);
  runApp(const CastOrNot());
}

//TODO: These two methods can be morphed into a single method.
Future<void> setApiKey(FirebaseRemoteConfig remoteConfig) async {
  ApiKey apiKey = ApiKey();
  String apiKeyString = remoteConfig.getString('podcast_index_api_key');
  apiKey.setKey(apiKeyString);
}

Future<void> setApiSecret(FirebaseRemoteConfig remoteConfig) async {
  ApiSecret apiSecret = ApiSecret();
  String apiSecretString = remoteConfig.getString('podcast_index_api_secret');
  apiSecret.setSecret(apiSecretString);
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