import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:voting_dapp/firebase_options.dart';
import 'package:voting_dapp/pages/instruction_page.dart';
import 'package:voting_dapp/pages/login_page.dart';
import 'package:voting_dapp/pages/registration_page.dart';
import 'package:voting_dapp/pages/signIn_page.dart';
import 'package:voting_dapp/pages/voting_page.dart';
import 'package:voting_dapp/pages/result_page.dart';
import 'package:voting_dapp/utils/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPref().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voting DApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          elevation: 1,
          centerTitle: true,
        ),
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/singIn': (context) => const SignInPage(),
        '/registration': (context) => const RegistrationPage(),
        '/voting': (context) => const VotingPage(),
        '/result': (context) => const ResultPage(),
        '/instruction': (context) => const InstructionPage(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return const InstructionPage();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
