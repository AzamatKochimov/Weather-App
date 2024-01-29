import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_uz/models/weather_model2.dart';
import '../servers/api_server.dart';
import '../services/dio_service.dart';
import '../widgets/background_weather_page.dart';

class WeatherDetailsPage extends StatefulWidget {
  final String cityName;

  const WeatherDetailsPage({
    Key? key,
    required this.cityName,
  }) : super(key: key);

  @override
  _WeatherDetailsPageState createState() => _WeatherDetailsPageState();
}

class _WeatherDetailsPageState extends State<WeatherDetailsPage> {
  double temperature = 0.0;
  late WeatherModel2 weather;
  String? errorMessage;
  int? humidity;
  double? windSpeed;
  double? feelsLike;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWeatherDetails();
  }
  void fetchWeatherDetails() async {

    try {
      String? response = await DioService.get(
        context,
        ApiServer.apiGetAllData,
        ApiServer.paramGetWeather(widget.cityName),
      );
      if (response != null) {
        final Map<String, dynamic> jsonResult = jsonDecode(response);
        log(jsonResult.toString());
        log("jsonResult: $jsonResult");
        try {
          weather = WeatherModel2.fromJson(jsonResult, widget.cityName);
        } catch (e) {
          log("Error parsing weather: $e");
        }

        setState(() {
          temperature = weather.temperature ?? 0.0;
          feelsLike = weather.feelsLike;
          humidity = weather.humidity;
          windSpeed = weather.windSpeed;
          isLoading = true;
        });
        log(weather.toString());
      } else {
        setState(() {
          errorMessage = 'Failed to load weather data!';
          isLoading = true;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WeatherDetailsPageBackground(
      child: isLoading
          ? Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  widget.cityName,
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  Container(
                      padding: const EdgeInsets.only(right: 20),
                      child: Image.asset('assets/icons/search right.png'))
                ],
                backgroundColor: Colors.transparent,
              ),
              body: buildWeatherDetails(),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildWeatherDetails() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM').format(now);
    String formattedTime = DateFormat('hh:mm a').format(now.toLocal());

    int timeZoneOffset = now.timeZoneOffset
        .inHours;
    String offsetSign =
        timeZoneOffset >= 0 ? '+' : '';
    String gmtString = 'GMT$offsetSign$timeZoneOffset';

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Today, $formattedDate",
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Updated as of $formattedTime $gmtString",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(
            height: 200,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Windy",
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "${temperature.toString()}°C",
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "assets/icons/drop.png",
                        width: 30,
                        height: 30,
                      ),
                      const Text(
                        "HUMIDITY",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${humidity.toString()}%",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        "assets/icons/wind-sign.png",
                        width: 30,
                        height: 30,
                      ),
                      const Text(
                        "WIND",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${windSpeed.toString()} km/h",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        "assets/icons/thermometer.png",
                        width: 30,
                        height: 30,
                      ),
                      const Text(
                        "FEELS LIKE",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${feelsLike.toString()}°C",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          showFiveDaysWeather(),
        ],
      ),
    );
  }

  Widget showFiveDaysWeather() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 160,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.24),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.5),
              )
            ],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildWeatherColumn(DateTime.now(), "sun", "${temperature.toString()}°C", windSpeed.toString()),
              _buildWeatherColumn(
                  DateTime.now().add(const Duration(days: 1)), "cloudy", "${temperature.toString()}°C", windSpeed.toString()),
              _buildWeatherColumn(
                  DateTime.now().add(const Duration(days: 2)),  "rain", "${temperature.toString()}°C", windSpeed.toString()),
              _buildWeatherColumn(
                  DateTime.now().add(const Duration(days: 3)), "snow", "${temperature.toString()}°C", windSpeed.toString()),
            ],
          ),
        ),
      ),
    );
  }
   Column _buildWeatherColumn(DateTime date, String weatherIcon, String weather, String wind) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          DateFormat('E d')
              .format(date), // Short weekday name and day of the month
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            "assets/icons/$weatherIcon.png",
            width: 40,
            height: 30,
          ),
        ),
        Text(
          weather,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Text(
          wind,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        const Text("km/h", style: TextStyle(color: Colors.white, fontSize: 16),
        )
      ],
    );
  }
}