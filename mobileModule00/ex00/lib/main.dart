import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('A simple text', style: TextStyle(fontSize: 20)),
              ElevatedButton(
                onPressed: () {
                  print('Button pressed'); // console
                },
                child: Text('Click Me'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

