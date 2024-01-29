import 'package:flutter/material.dart';

class WeatherDetailsPageBackground extends StatelessWidget {
  final Widget child;
  const WeatherDetailsPageBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/w1.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
