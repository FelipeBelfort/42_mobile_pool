import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'firebase_options.dart';
import 'google_sign_in.dart';


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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _user != null
            ?_userPage()
            :_signInButton(),
          ],
        ),
      ),
    );
  }

  Widget _signInButton() {
    return SignInButton(
      Buttons.google, 
      // onPressed: () => debugPrint('button pressed'));
      onPressed: _handleGoogleSignIn,
      );
  }

  Widget _userPage() {
    return Text('Welcome ');
  }

  void _handleGoogleSignIn() async {
    try {
      UserCredential? _userCredential = await signInWithGoogle(
        // clientId: '696347209276-p9s1m8ds8nh3a88i349pi8g0vgkbq1gp.apps.googleusercontent.com';
      );

      if (_userCredential != null) {
        setState(() {
          _user = _userCredential.user;
        });
      }
      // GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      // _auth.signInWithProvider(googleAuthProvider);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

}

