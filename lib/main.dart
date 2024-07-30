import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';

void main() {
  runApp(const Weather());
}

class Weather  extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _HomescreenState();
}

  class _HomescreenState extends State<Weather> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const WeatherScreen(),
    );
  }
}
