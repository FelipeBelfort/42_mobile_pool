import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HelloWorldScreen(),
    );
  }
}

class HelloWorldScreen extends StatefulWidget {
  const HelloWorldScreen({super.key});
  @override
  State<HelloWorldScreen> createState() => _HelloWorldScreenState();
}

class _HelloWorldScreenState extends State<HelloWorldScreen> {
  String displayedText = 'A simple text';

  void toggleText() {
    setState(() {
      displayedText = (displayedText == 'A simple text')
          ? 'Hello World!'
          : 'A simple text';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(displayedText, style: TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: toggleText,
              child: Text('Click Me'),
            ),
          ],
        ),
      ),
    );
  }
}
