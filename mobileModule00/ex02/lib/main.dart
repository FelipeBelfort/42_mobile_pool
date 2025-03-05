import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 139, 150, 173)),
      ),
      home: const MyHomePage(title: 'Calculator'),
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

  double _getTextSize(value, isLandscape) {
    if (value == '=') {return 0.4 * isLandscape;}
    if (value == '00' || value == 'AC') {return 0.12 * isLandscape;}
    return 0.25 * isLandscape;
  }

  Widget _genButtons() {
    
    return LayoutBuilder(
      builder: (context, constraints){
        double buttonWidth = constraints.maxWidth / 5;
        double buttonHeight = constraints.maxHeight / 4.5;

        double buttonSize = buttonHeight < buttonWidth ? buttonHeight : buttonWidth;
        int isLandscape = buttonSize == buttonWidth ? 1 : 2;
      return GridView.count(
          crossAxisCount: 5, // buttons in line
          childAspectRatio: buttonWidth / buttonSize,
          padding: EdgeInsets.all(buttonSize * 0.05),
          children: [
            '7', '8', '9', 'C', 'AC',
            '4', '5', '6', '+', '-',
            '1', '2', '3', 'x', '=',
            '0', '.', '00', '/',
          ].map((value) {
              return Padding(
              padding: EdgeInsets.all(buttonSize * 0.05),
              child: ElevatedButton(
                onPressed: () => print(value),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize: buttonSize * _getTextSize(value, isLandscape))
                ),
                child: Text(value),
              ),
            );
        }).toList(),
    );
    },);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('0'),
                  Text('0'),
                ],
              ),
              ),
            MediaQuery.of(context).size.aspectRatio < 1 ? Spacer() : Text(''),
            Expanded(child: _genButtons()),
          ],
        ),
    );
  }
}




