import 'package:flutter/material.dart';
import 'geolocation.dart';
import 'search_location.dart';
import 'tab_manager.dart';

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
      theme: ThemeData.dark(),
      home: WeatherHomePage(tabs: tabs),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({required this.tabs, super.key});

  final List<Tab> tabs;

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();

}

class _WeatherHomePageState extends State<WeatherHomePage> {

  final TextEditingController _textController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _getLocation() async {
    String location = await GeoLocator.determinePosition();
    List<Map<String, dynamic>> list = await SearchService.searchByLocation(location);
    if (list.isNotEmpty) {
    _updateText(list[0]);
    }
  }

  Future<void> _searching(String text) async{
    List<Map<String, dynamic>> list = await SearchService.searchCity(text);

    setState(() {
      _searchResults = list;
    });
  }

  void _updateText(city) {

    setState(() {
      TabViewManager.setData(city);
      _textController.clear();
      _searchResults.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      child: DefaultTabControllerListener(
        onTabChanged: (int index) {debugPrint('tab: $index');},
        child: Scaffold(
          appBar: AppBar(
              title: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onChanged: _searching,
                      onSubmitted: (text) => _updateText(_searchResults[0]),
                      decoration: InputDecoration(
                        hintText: "Search location...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),)
                    ),
                  IconButton(
                    onPressed: _getLocation,
                    icon: Icon(Icons.my_location_rounded),
                    )
                ],
                ),
            ),
          body: _searchResults.isEmpty
            ? TabBarView(
                children: widget.tabs.map((Tab tab) {
                  return Center(
                    child: TabViewManager.getTabView('${tab.text}'),
                    );
                }).toList(),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final city = _searchResults[index];
                    return ListTile(
                      title: Text("${city['name']}"),
                      subtitle: Text("${city['admin1']}, ${city['country']}"),
                      onTap: () => _updateText(city),
                    );
                  },
                ),
                ),
          bottomNavigationBar: TabBar(tabs: widget.tabs),
        ),
        ),
      );
  }
}

