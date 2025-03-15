import 'package:diary_app/calendar_page.dart';
import 'package:diary_app/github_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'firebase_options.dart';
import 'google_sign_in.dart';
import 'user_page.dart';
import 'tab_controller.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const List<Tab> tabs = <Tab>[
    Tab(icon: Icon(Icons.person),),
    Tab(icon: Icon(Icons.calendar_month),),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'diary_app', tabs: tabs,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.tabs, required this.title});

  final String title;
  final List<Tab> tabs;


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
    return DefaultTabController(
      length: widget.tabs.length,
      child: DefaultTabControllerListener(
        onTabChanged: (int index) {debugPrint('tab: $index');},
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            actions: [
              _user != null
              ?IconButton(
                icon: Icon(Icons.logout),
                onPressed: _handleSignOut,
                )
              :Container(),
            ],
          ),
          body: Center(
              child: _user != null
                ?TabBarView(
                  children: [
                    ProfilePage(),
                    CalendarPage(),
                  ],
                )
                :Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _signInButton(true),
                    Text(''),
                    _signInButton(false),
                  ],
                ),
            ),
          bottomNavigationBar: _user != null
          ?TabBar(tabs: widget.tabs,)
          :Row(),
          ),
      ),
    );
  }

  Future<void> _handleSignOut() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Sign out from Google (if using Google login)
      await GoogleSignIn().signOut();
    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }

  Widget _signInButton(bool isGoogle) {
    return SignInButton(
      isGoogle
      ?Buttons.google
      :Buttons.gitHub,
      onPressed: () => _handleSignIn(isGoogle ? signInWithGoogle : signInWithGitHub),
      );
  }

  void _handleSignIn(func) async {
    try {
      UserCredential? userCredential = await func();

      if (userCredential != null) {
        setState(() {
          _user = userCredential.user;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }

  }

}

