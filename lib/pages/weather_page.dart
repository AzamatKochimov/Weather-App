import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_uz/pages/weather_details.dart';

import '../models/weather_model.dart';
import '../servers/api_server.dart';
import '../services/dio_service.dart';
import '../widgets/city_weather_widget.dart';
import '../widgets/custom_scaffold.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  Map<String, String> listOfCities = {
    "Tashkent": "UZ",
    "Andijan": "UZ",
    "Kabul": "AF",
    "London": "UK",
    "Moscow": "RU",
    "Sweden": "SE",
    "Berlin": "DE",
    "Pekin": "CN",
    "Samarkand": "UZ",
    "Bukhara": "UZ",
    "Istanbul": "TR",
    "Ankara": "TR",
  };
  Map<String, double> cityTemperatures = {};
  List<String> listOfImages = [
    "img1.png",
    "img2.png",
    "img3.png",
    "img4.jpg",
    "img5.jpg",
    "img6.png",
    "img1.png",
    "img2.png",
    "img3.png",
    "img4.jpg",
    "img5.jpg",
    "img6.png",
  ];

  @override
  void initState() {
    super.initState();
    fetchAllCityTemperatures();
  }

  void fetchAllCityTemperatures() async {
    for (String city in listOfCities.keys) {
      await updateWeather(city);
    }
    setState(() {
      isLoading = true;
    });
  }

  Future<void> updateWeather(String city) async {
    String? result = await DioService.get(
      context,
      ApiServer.apiGetAllData,
      ApiServer.paramGetWeather(city),
    );
    if (result != null) {
      Map<String, dynamic> jsonResult = json.decode(result);
      WeatherModel weather =
          WeatherModel.fromJson(jsonResult, listOfCities[city]);
      setState(() {
        cityTemperatures[city] = weather.temperature;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: isLoading
          ? Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Image.asset(
                    "assets/icons/maps.png",
                    width: 34,
                    height: 34,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: Image.asset(
                      "assets/icons/notification.png",
                      width: 34,
                    ),
                  ),
                ],
              ),
              body: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            margin: const EdgeInsets.only(right: 20),
                            child: TextField(
                              onSubmitted: (city) {
                                
                              },
                              controller: textEditingController,
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.search,
                                    color: Colors.white),
                                contentPadding: const EdgeInsets.only(left: 15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 255, 255, 0.8),
                                    )),
                                focusColor:
                                    const Color.fromRGBO(255, 255, 255, 0.8),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Color.fromRGBO(255, 255, 255, 0.8),
                                    )),
                                filled: true,
                                fillColor:
                                    const Color.fromRGBO(255, 255, 255, 0.2),
                              ),
                            ),
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(CupertinoIcons.add, color: Colors.white),
                            SizedBox(width: 8),
                            Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(CupertinoIcons.pencil,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listOfCities.length,
                        itemBuilder: (context, index) {
                          String cityName = listOfCities.keys.toList()[index];
                          double temperature =
                              cityTemperatures[cityName] ?? 0.0;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      WeatherDetailsPage(cityName: cityName),
                                ),
                              );
                            },
                            child: CityWeatherContainer(
                              cityName: cityName,
                              countryShortcut: listOfCities[cityName] ?? "",
                              temperature: temperature,
                              backgroundImage: AssetImage(
                                "assets/images/${listOfImages[index % listOfImages.length]}",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
