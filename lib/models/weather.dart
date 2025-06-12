class Weather {
  final String description;
  final double temperature;
  final String city;

  Weather({required this.description, required this.temperature, required this.city});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['weather'][0]['main'],
      temperature: json['main']['temp'].toDouble(),
      city: json['name'],
    );
  }
}
