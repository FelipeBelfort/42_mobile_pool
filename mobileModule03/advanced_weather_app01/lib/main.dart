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
      debugShowCheckedModeBanner: false,
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
  String _errorMsg = "";

  Future<void> _getLocation() async {
    String location = await GeoLocator.determinePosition();
    if (GeoLocator.errorList.contains(location)) {
      setState(() {
        _errorMsg = location;
        _textController.clear();
      _searchResults.clear();
      });
      return;
    }
    List<Map<String, dynamic>> list = await SearchService.searchByLocation(location);
    if (list.isEmpty) {
      _errorHandler("Sorry! It seems that the API connection failed");
      return;
    }
    _updateText(list[0]);
  }

  Future<void> _searching(String text) async{
    List<Map<String, dynamic>> list = await SearchService.searchCity(text);
    setState(() {
      _searchResults = list;
    });
  }

  void _errorHandler(String errorMsg) {
    setState(() {
      _textController.clear();
      _searchResults.clear();
      _errorMsg = errorMsg;
    });
  }

  void _submitButton() {
    if (_searchResults.isNotEmpty) {
      _updateText(_searchResults[0]);
      return;
    }
    _errorHandler("Sorry! API failed or that city does not exist");
  }

  void _updateText(city) {
    setState(() {
      TabViewManager.setData(city);
      _textController.clear();
      _searchResults.clear();
      _errorMsg = "";
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
        child: BackgroundWrapper(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(94, 158, 158, 158),
              elevation: 0,
              title: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onChanged: _searching,
                      onSubmitted: (text) => _submitButton(),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(onPressed: () => _errorHandler(''), icon: Icon(Icons.cancel)),
                        labelText: "Search here...",
                        hintText: "City name",
                    ),)
                    ),
                  IconButton(
                    onPressed: _getLocation,
                    icon: Icon(Icons.location_on_outlined),
                    )
                ],
                ),
              ),
            body: _searchResults.isEmpty
              ? TabBarView(
                  children: widget.tabs.map((Tab tab) {
                    return Center(
                      child: _errorMsg.isEmpty 
                    ? TabViewManager.getTabView('${tab.text}')
                    : Text(_errorMsg),
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
            bottomNavigationBar: Container(
              color: Colors.white24,
              child: TabBar(tabs: widget.tabs),
            ),
          ),
      ),
        ),
      );
  }
}

class BackgroundWrapper extends StatelessWidget {
  final Widget child; 

  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/background2.jpg",
            fit: BoxFit.cover,
          ),
        ),
        child,
      ],
    );
  }
}