import 'package:diary_app/github_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'firebase_options.dart';
import 'google_sign_in.dart';
import 'user_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'diary_app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: _user != null
            ?ProfilePage()
            :Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _signInButton(true),
                Text(''),
                _signInButton(false),
              ],
            ), 
      ),
    );
  }

  Widget _signInButton(bool isGoogle) {
    return SignInButton(
      isGoogle
      ?Buttons.google
      :Buttons.gitHub, 
      onPressed: () => _handleSignIn(isGoogle ? signInWithGoogle : signInWithGitHub),
      );
  }

  // Widget _userPage() {
  //   return Text('Welcome ${_user!.email}');
  // }

  void _handleSignIn(func) async {
    try {
      UserCredential? _userCredential = await func();

      if (_userCredential != null) {
        setState(() {
          _user = _userCredential.user;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  
  }

}

