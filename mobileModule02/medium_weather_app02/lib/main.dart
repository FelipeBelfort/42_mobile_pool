import 'package:flutter/material.dart';
import 'geolocation.dart';
import 'search_location.dart';
import 'tab_manager.dart';
import 'weather_service.dart';

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

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({required this.tabs, super.key});

  final List<Tab> tabs;

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();

}

class _WeatherHomePageState extends State<WeatherHomePage> {

  Map<String, dynamic> cityData = {};
  Map<String, dynamic> weatherData = {};

  Map<String, dynamic> searchedText = {};
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

  Widget _getTabView(String tabName) {
    if (cityData.isEmpty || weatherData.isEmpty) {
      return Text('Searching...');
    }

    switch (tabName) {
      case 'Currently':
        // debugPrint('passei aqui');
        return _getCurrentlyView();
      // case 'Today':
      // case 'Weekly':
    }
    
    return Text('Error');
  }

  Widget _getCurrentlyView() {
    debugPrint(cityData.toString());

    return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${cityData['name']}"),
                    Text("${cityData['state']}"),
                    Text("${cityData['country']}"),
                    Text("${weatherData['current']['temperature_2m']}°C"),
                    Text(" ${getWeatherIcon(weatherData['current']['weather_code'])}"),
                    Text("${weatherData['current']['wind_speed_10m']} Km/h"),
                  ],
                  );
  }

  Future<void> _fetchWeather(Map<String, dynamic> city) async {
    String lat = 'lat';
    String lon = 'lon';
    if (city[lat] == null) {
      lat = 'latitude';
      lon = 'longitude';
    }
    if (city['state'] == null) {
      city['state'] = city['admin1'];
    }
    Map<String, dynamic> weather = await WeatherService.getWeather(city[lat], city[lon]);
    // tabView.setData(city, weather);
    // debugPrint(weather.toString());
    setState(() {
      // tabView.hydrate(city, weather);
      cityData = city;
      weatherData = weather;
      // searchedText['weather'] = weather['current']['temperature_2m'];
      
    });

  }

  void _updateText(city) {

    setState(() {
      // searchedText = city;
      _fetchWeather(city);
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
    // debugPrint(context.toString());
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
          ?TabBarView(
            children: widget.tabs.map((Tab tab) {
              return _getTabView('${tab.text}');
              // return Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       // Text('${tab.text}'),
              //       Text(searchedText.isEmpty ? "Charging..." : searchedText['name']),
              //       Text(searchedText.isEmpty ? "" : "${searchedText['weather']}°C"),
              //     ],
              //     ),
              // );
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

String getWeatherIcon(int code) {
    switch (code) {
      case 0:
        return "☀️ Clear sky";
      case 1:
      case 2:
      case 3:
        return "⛅ Mainly clear, partly cloudy, and overcast";
      case 45:
      case 48:
        return "🌫️ Fog and depositing rime fog";
      case 51:
      case 53:
      case 55:
        return "🌦️ Drizzle: Light, moderate, and dense intensity";
      case 56:
      case 57:
        return "❄️ Freezing Drizzle: Light and dense intensity";
      case 61:
      case 63:
      case 65:
        return "🌧️ Rain: Slight, moderate and heavy intensity";
      case 66:
      case 67:
        return "❄️ Freezing Rain: Light and heavy intensity";
      case 71:
      case 73:
      case 75:
        return "❄️ Snow fall: Slight, moderate, and heavy intensity";
      case 77:
        return "❄️ Snow grains";
      case 80:
      case 81:
      case 82:
        return "🌦️ Rain showers: Slight, moderate, and violent";
      case 85:
      case 86:
        return "🌨️ Snow showers slight and heavy";
      case 95:
        return "⛈️ Thunderstorm: Slight or moderate";
      case 96:
      case 99:
        return "⛈️🌨️ Thunderstorm with slight and heavy hail";
      default:
        return "❓ Unknown weather conditions";
    }
  }