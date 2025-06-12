import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:weather_app/models/theme_controller.dart';
import 'package:weather_app/services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentCity = "Miami";
  final TextEditingController _controller = TextEditingController();
  double? currentTemp;
  String tempRange = "";
  bool isLoading = false;
  List<Map<String, dynamic>> dailyForecast = [];
  String currentCondition = 'Clear';
  List<String> hourlyConditions = [];

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() => isLoading = true);
    try {
      final data = await WeatherService.fetchWeather(currentCity);
      final forecast = await WeatherService.fetch5DayForecast(currentCity);
      currentCondition = data['weather'][0]['main'] ?? 'Clear';

      List<String> hours = forecast
          .take(5)
          .map<String>((e) => e['weather']?.toString() ?? 'Clear')
          .toList();

      setState(() {
        currentTemp = data['main']['temp']?.toDouble();
        double min = data['main']['temp_min']?.toDouble();
        double max = data['main']['temp_max']?.toDouble();
        tempRange = "${min.toInt()}°/${max.toInt()}°";
        dailyForecast = forecast;
        hourlyConditions = hours;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("City not found")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _updateCity() {
    final newCity = _controller.text.trim();
    if (newCity.isNotEmpty) {
      setState(() => currentCity = newCity);
      _fetchWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("3D Weather"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ThemeController.toggleTheme(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF263238), const Color(0xFF1c1f1f)]
                : [const Color(0xFF6D6AD3), const Color(0xFF6DBEF2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView( // ✅ Added scrollable container
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _controller,
                    onSubmitted: (_) => _updateCity(),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: "Enter city name",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _updateCity,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentCity,
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  /// Dynamic weather icon
                  Icon(
                    _mapWeatherToIcon(currentCondition),
                    size: 100,
                    color: Colors.yellow,
                  ),

                  const SizedBox(height: 20),
                  Text(
                    isLoading
                        ? "Loading..."
                        : currentTemp != null
                        ? "${currentTemp!.toInt()}°"
                        : "--°",
                    style: const TextStyle(
                      fontSize: 64,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    tempRange,
                    style:
                    const TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),
                  _buildHourlyForecast(),
                  const SizedBox(height: 30),
                  _buildDailyForecast(),
                  const SizedBox(height: 40), // space at bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHourlyForecast() {
    final hours = ['Now', '12', '13', '14', '15'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          hours.length,
              (index) {
            final condition = index < hourlyConditions.length
                ? hourlyConditions[index]
                : 'Clear';
            return Column(
              children: [
                Text(hours[index],
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 4),
                Icon(
                  _mapWeatherToIcon(condition),
                  color: Colors.white70,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDailyForecast() {
    return Column(
      children: List.generate(dailyForecast.length, (index) {
        final dayData = dailyForecast[index];
        final date = DateTime.parse(dayData['date']);
        final min = dayData['tempMin'].toInt();
        final max = dayData['tempMax'].toInt();
        final weather = dayData['weather'] ?? 'Clear';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getWeekday(date),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Icon(_mapWeatherToIcon(weather), color: Colors.white70),
              Text("$min° / $max°",
                  style: const TextStyle(color: Colors.white70)),
            ],
          ),
        );
      }),
    );
  }

  String _getWeekday(DateTime date) {
    const weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    return weekdays[date.weekday % 7];
  }

  IconData _mapWeatherToIcon(String weather) {
    switch (weather.toLowerCase()) {
      case 'rain':
        return Icons.umbrella;
      case 'clouds':
        return Icons.cloud;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.bolt;
      case 'drizzle':
        return Icons.grain;
      case 'mist':
      case 'fog':
        return Icons.blur_on;
      case 'clear':
      default:
        return Icons.wb_sunny;
    }
  }
}
