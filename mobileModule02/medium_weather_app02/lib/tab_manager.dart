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

  static Future<void> updateWeather() async {
    if (TabViewManager.lat == 0 || TabViewManager.lon == 0) {
      return;
    }
    Map<String, dynamic> weatherData = await WeatherService.getWeather(TabViewManager.lat, TabViewManager.lon);

    if (weatherData.isEmpty) {
      return;
    }
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

  Widget _getCurrentlyView() {

    return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(TabViewManager.city),
                    Text(TabViewManager.state),
                    Text(TabViewManager.country),
                    Text("${TabViewManager.curr['temperature_2m']}°C"),
                    Text(getWeatherIcon(TabViewManager.curr['weather_code'])),
                    Text("${TabViewManager.curr['wind_speed_10m']} Km/h"),
                  ],
                  );
  }

  Widget _getTodayView() {
    debugPrint(TabViewManager.daily.toString());
        return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(TabViewManager.city),
                    Text(TabViewManager.state),
                    Text(TabViewManager.country),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 24,
                        itemBuilder: (context, index) {
                          final hour = TabViewManager.hourly['time'][index];
                          final temp = TabViewManager.hourly['temperature_2m'][index];
                          final wind = TabViewManager.hourly['wind_speed_10m'][index];
                          return ListTile(
                            leading: Text(hour.split('T')[1]),
                            title: Text("$temp°C"),
                            trailing: Text("$wind Km/h"),
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
                    Text(TabViewManager.state),
                    Text(TabViewManager.country),
                    Expanded(
                      child: ListView.builder(
                        itemCount: TabViewManager.daily['time'].length,
                        itemBuilder: (context, index) {
                          final day = TabViewManager.daily['time'][index];
                          final max = TabViewManager.daily['temperature_2m_max'][index];
                          final min = TabViewManager.daily['temperature_2m_min'][index];
                          final code = TabViewManager.daily['weather_code'][index];
                          return ListTile(
                            leading: Text(day),
                            title: Text(getWeatherIcon(code)),
                            // subtitle: Text(),
                            trailing: Text("$min°C / $max°C"),
                          );
                        },
                      ),
                    ),
                  ],
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
