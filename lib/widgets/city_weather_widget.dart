import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CityWeatherContainer extends StatelessWidget {
  final String cityName;
  final double temperature;
  late AssetImage backgroundImage;
  final String countryShortcut;
  CityWeatherContainer({
    super.key,
    required this.cityName,
    required this.temperature,
    required this.backgroundImage,
    required this.countryShortcut,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 100,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: backgroundImage,
            fit: BoxFit.cover,
          ),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(89, 87, 87, 0.4), offset: Offset(2, 6))
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cityName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        countryShortcut,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Image.asset("assets/icons/location.png",
                      width: 14, height: 14),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/cloudy.png", width: 40, height: 36),
                  Text(
                    '$temperature°C',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
