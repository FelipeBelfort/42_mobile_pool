import 'package:flutter/material.dart';
import 'weather_service.dart';

class TabViewManager {
  static String city = '';
  static String state = '';
  static String country = '';
  static double lat = 0;
  static double lon = 0;
  static Map<String, dynamic> curr = {};
  static Map<String, dynamic> hourly = {};
  static Map<String, dynamic> daily = {};
  static bool apiError = false;

  static Future<void> updateWeather() async {
    if (TabViewManager.lat == 0 || TabViewManager.lon == 0) {
      return;
    }
    Map<String, dynamic> weatherData = await WeatherService.getWeather(TabViewManager.lat, TabViewManager.lon);

    if (weatherData.isEmpty) {
      TabViewManager.apiError = true;
      return;
    }
    TabViewManager.apiError = false;
    TabViewManager.curr = weatherData['current'];
    TabViewManager.hourly = weatherData['hourly'];
    TabViewManager.daily = weatherData['daily'];
  }

  Future<void> _getCachedData() async {
    if (TabViewManager.city.isEmpty || TabViewManager.curr.isEmpty) {
      return Future.value();
    }
    return Future.error("No data available");
  }

  static void setData(Map<String, dynamic> cityData) {
    TabViewManager.city = cityData['name'];
    if (cityData['id'] == null) {
      TabViewManager.state = cityData['state'];
      TabViewManager.country = cityData['country'];
      TabViewManager.lat = cityData['lat'];
      TabViewManager.lon = cityData['lon'];
    } else {
      TabViewManager.state = cityData['admin1'];
      TabViewManager.country = cityData['country_code'];
      TabViewManager.lat = cityData['latitude'];
      TabViewManager.lon = cityData['longitude'];
    }
    updateWeather();
  }

  static Widget getTabView(tabName) {
    TabViewManager instance = TabViewManager();
    if (TabViewManager.apiError) {
      return Text('API connection failed');
    }
    if (TabViewManager.city.isEmpty || TabViewManager.curr.isEmpty) {
      return FutureBuilder(
        future: instance._getCachedData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Searching...');
          } else if (snapshot.hasError) {
            return Text('Error loading data');
          } else {
            return getTabView(tabName);
          }
        },
      );
    }

    switch (tabName) {
      case 'Currently':
        return instance._getCurrentlyView();
      case 'Today':
        return instance._getTodayView();
      case 'Weekly':
        return instance._getWeeklyView();
    }

    return Text('Error');
  }

  Widget _expandedFittedBox(List<Widget> list) {
    return Expanded(
            child: FittedBox(
              fit: BoxFit.fill,
              child: Column(
                children: list,
              ),
            ),
          );
  }

  Widget _getCurrentlyView() {
    // final double screenSize = MediaQuery.of(context).size.height;
    // debugPrint("$screenSize");
    return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text(''),
                    // Spacer(),
                    _expandedFittedBox([
                      Text(TabViewManager.city),
                      Text("${TabViewManager.state}, ${TabViewManager.country}"),
                    ]),
                      Text(''),
                    // Spacer(),
                    _expandedFittedBox([
                      Text("${TabViewManager.curr['temperature_2m']}°C"),
                    ]),
                    _expandedFittedBox([
                      Text(getWeatherIcon(TabViewManager.curr['weather_code'])),
                    ]),
                    _expandedFittedBox([
                      Text(getWeatherDescription(TabViewManager.curr['weather_code'])),
                      Text(''),
                    ]),
                    _expandedFittedBox([
                      Padding(
                        padding: EdgeInsets.all(7.4),
                        child: Text("༄ ${TabViewManager.curr['wind_speed_10m']} Km/h"),
                      ),

                      // Text(''),
                      // Text(''),
                    ]),
                      Text(''),
                    // Spacer(),
                  ],
                  );
  }

  Widget _getTodayView() {
        return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(TabViewManager.city),
                    Text("${TabViewManager.state}, ${TabViewManager.country}"),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 24,
                        itemBuilder: (context, index) {
                          final hour = TabViewManager.hourly['time'][index];
                          final temp = TabViewManager.hourly['temperature_2m'][index];
                          final wind = TabViewManager.hourly['wind_speed_10m'][index];
                          return ListTile(
                            leading: Text(hour.split('T')[1], style: TextStyle(color: Colors.black),),
                            title: Center(child: Text("$temp°C")),
                            trailing: Text("$wind Km/h", style: TextStyle(color: Colors.black),),
                          );
                        },
                      ),
                    ),
                  ],
                  );
  }

  Widget _getWeeklyView() {
        return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(TabViewManager.city),
                    Text("${TabViewManager.state}, ${TabViewManager.country}"),
                    Expanded(
                      child: ListView.builder(
                        itemCount: TabViewManager.daily['time'].length,
                        itemBuilder: (context, index) {
                          final day = TabViewManager.daily['time'][index];
                          final max = TabViewManager.daily['temperature_2m_max'][index];
                          final min = TabViewManager.daily['temperature_2m_min'][index];
                          final code = TabViewManager.daily['weather_code'][index];
                          return ListTile(
                            leading: Text(day, style: TextStyle(color: Colors.black),),
                            title: Center(child: Text(getWeatherIcon(code))),
                            subtitle: Center(child: Text(getWeatherDescription(code), style: TextStyle(color: Colors.black),)),
                            trailing: Text("$min°C / $max°C", style: TextStyle(color: Colors.black),),
                          );
                        },
                      ),
                    ),
                  ],
                  );
  }
}

String getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return "Clear sky";
      case 1:
        return "Mainly clear";
      case 2:
        return "Partly cloudy";
      case 3:
        return "Overcast";
      case 45:
        return "Fog";
      case 48:
        return "Depositing rime fog";
      case 51:
        return "Drizzle: Light";
      case 53:
        return "Drizzle: Moderate";
      case 55:
        return "Drizzle: Dense intensity";
      case 56:
        return "Freezing Drizzle: Light";
      case 57:
        return "Freezing Drizzle: Dense intensity";
      case 61:
        return "Rain: Slight";
      case 63:
        return "Rain: Moderate";
      case 65:
        return "Rain: Heavy intensity";
      case 66:
        return "Freezing Rain: Light";
      case 67:
        return "Freezing Rain: Heavy intensity";
      case 71:
        return "Snow fall: Slight";
      case 73:
        return "Snow fall: Moderate";
      case 75:
        return "Snow fall: Heavy intensity";
      case 77:
        return "Snow grains";
      case 80:
        return "Rain showers: Slight";
      case 81:
        return "Rain showers: Moderate";
      case 82:
        return "Rain showers: Violent";
      case 85:
        return "Snow showers slight";
      case 86:
        return "Snow showers heavy";
      case 95:
        return "Thunderstorm: Slight or moderate";
      case 96:
        return "Thunderstorm with slight hail";
      case 99:
        return "Thunderstorm with heavy hail";
      default:
        return "Unknown weather conditions";
    }
}

String getWeatherIcon(int code) {

      if (code == 0) {return "☀️";}
      if (code <= 3) {return "⛅";}
      if (code == 45 || code == 48) {return "🌫️";}
      if (code >= 51 && code <= 55) {return "🌦️";}
      if (code >= 61 && code <= 65) {return "🌧️";}
      if (code >= 80 && code <= 82) {return "🌧️";}
      if (code <= 77) {return "❄️";}
      if (code == 85 || code == 86) {return "🌨️";}
      if (code == 95) {return "⛈️";}
      if (code == 99 || code == 96) {return "⛈️🌨️";}
        return "❓";
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
    // return widget.child;
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/background2.jpg",
            fit: BoxFit.cover,
          ),
        ),
        widget.child,
      ],
    );
  }
}
