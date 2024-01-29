import 'dart:convert';

class WeatherModel2 {
  final double? temperature;
  final double? feelsLike;
  final int? humidity;
  final double? windSpeed;

  WeatherModel2({
    this.temperature,
    this.feelsLike,
    this.humidity,
    this.windSpeed,
  });

  factory WeatherModel2.fromJson(Map<String, dynamic> json, String? cityName) {
    return WeatherModel2(
      temperature: json['temp']?.toDouble() ?? 0.0,
      feelsLike: json['feels_like']?.toDouble() ?? 0.0,
      humidity: json['humidity']?.toInt() ?? 0,
      windSpeed: json['wind_speed']?.toDouble() ?? 0.0,
    );
  }
}

String weatherModelToJson(WeatherModel2 data) {
  final Map<String, dynamic> jsonMap = {
    'temp': data.temperature ?? 0.0,
    'feels_like': data.feelsLike,
    'humidity': data.humidity,
    'wind_speed': data.windSpeed,
  };
  return json.encode(jsonMap);
}
