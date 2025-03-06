import 'package:flutter/material.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  static const List<Tab> tabs = <Tab>[
    Tab(text: "Currently", icon: Icon(Icons.timer),),
    Tab(text: "Today", icon: Icon(Icons.today),),
    Tab(text: "Weekly", icon: Icon(Icons.view_week),),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "WeatherApp",
      home: WeatherHomePage(tabs: tabs),
    );
  }
}

class WeatherHomePage extends StatelessWidget {
  const WeatherHomePage({required this.tabs, super.key});

  final List<Tab> tabs;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length, 
      child: DefaultTabControllerListener(
        onTabChanged: (int index) {debugPrint('tab: $index');}, 
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search location...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),)
                  ),
                IconButton(
                  onPressed: () => debugPrint('Geolocation'), 
                  icon: Icon(Icons.my_location_rounded),
                  )
              ],
            ),
            ),
          body: TabBarView(
            children: tabs.map((Tab tab) {
              return Center(
                child: Text('${tab.text}'),
              );
            }).toList(),
            ),
          bottomNavigationBar: TabBar(tabs: tabs),
        ),
        ),
      );
  }
}

class DefaultTabControllerListener extends StatefulWidget {
  const DefaultTabControllerListener({
    required this.onTabChanged,
    required this.child,
    super.key,
  });

  final ValueChanged<int> onTabChanged;
  final Widget child;
  
  @override
  State<DefaultTabControllerListener> createState() => _DefaultTabControllerListener();
}

class _DefaultTabControllerListener extends State<DefaultTabControllerListener> {
  late TabController _controller;

  void _listener() {
    final TabController? controller = _controller;

    if (controller == null || controller.indexIsChanging) {
      return;
    }
    widget.onTabChanged(controller.index);
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
