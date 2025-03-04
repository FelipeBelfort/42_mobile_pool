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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 139, 150, 173)),
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('0'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 40,),
            Expanded(
            child: GridView.count(
              crossAxisCount: 5, // 4 botões por linha
              padding: EdgeInsets.all(16),
              children: [
                '7', '8', '9', 'C', 'AC',
                '4', '5', '6', '+', '-',
                '1', '2', '3', 'x', '=',
                '0', '.', '00', '/',
              ].map((value) {
                if (value == '=') {
                  return GridTile(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => print(value),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(15, 70), // Ocupa espaço duplo
                          side: BorderSide() 
                        ),
                        child: Text(value, style: TextStyle(fontSize: 30)),
                      ),
                    ),
                  );
                } else {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => print(value),
                    child: Text(value, style: TextStyle(fontSize: 20)),
                  ),
                );
                }
              }).toList(),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
