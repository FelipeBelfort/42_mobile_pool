import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

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

  String result = '0';
  String input = '';

  void calculateResult() {
    try {
      // String sanitizedExpression = input.replaceAll(' ', '');
      // print("|$sanitizedExpression|");
      Parser parser = Parser();
      Expression exp = parser.parse(input);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      result = eval.toString();
    } catch (e) {
      result = 'Error';
    }
  }

  void _buttonPressed(String value) {

    setState(() {
      
      switch (value) {
        case 'AC':
          result = '0';
          input = '';
          break;
        case 'C':
          if (input.isNotEmpty) {
            input = input.substring(0, input.length - 1);
          }
          break;
        case '=':
          calculateResult();
          input = "";
          break;
        default:
          input += value;
      }
    });

  }

  Widget _genButtons() {
    
    return LayoutBuilder(
      builder: (context, constraints){
        double buttonWidth = constraints.maxWidth / 5;
        double buttonHeight = constraints.maxHeight / 4.5;

        double buttonSize = buttonHeight < buttonWidth ? buttonHeight : buttonWidth;
        double contextWidth = MediaQuery.of(context).size.width;
      return GridView.count(
          crossAxisCount: 5, // buttons in line
          childAspectRatio: buttonWidth / buttonHeight,
          padding: EdgeInsets.all(buttonSize * 0.05),
          children: [
            '7', '8', '9', 'C', 'AC',
            '4', '5', '6', '+', '-',
            '1', '2', '3', '*', '=',
            '0', '.', '00', '/',
          ].map((value) {
              return Padding(
              padding: EdgeInsets.all(buttonSize * 0.05),
              child: ElevatedButton(
                onPressed: () => _buttonPressed(value),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(fontSize:  value == '=' ? 0.06 * contextWidth : 0.04 * contextWidth)
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
    final double textSize = MediaQuery.of(context).size.height * 0.05;
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
                  Text(
                    result,
                    style: TextStyle(fontSize: textSize),
                    ),
                  Text(
                    input.isEmpty ? "0" : input,
                    style: TextStyle(fontSize: textSize), // think about longer inputs
                    ),
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




