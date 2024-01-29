import 'dart:convert';

Map<String, double> weatherModelFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, double>(k, v?.toDouble()));

String weatherModelToJson(Map<String, double> data) =>
    json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v)));

class WeatherModel {
  final double temperature;

  WeatherModel({required this.temperature,});

  factory WeatherModel.fromJson(Map<String, dynamic> json, String? listOfCities) {
    return WeatherModel(
      temperature: json['temp']?.toDouble() ?? 0.0,
    );
  }
}
