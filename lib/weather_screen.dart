import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secretsapi.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController textcityController = TextEditingController();
  final TextEditingController textcountryController = TextEditingController();
  double temp = 273.15;
  String sky = '';
  double wind = 0;
  int humidity = 0;
  int pressure = 0;
  bool isLoding = false;

  // void initState() {
  //   super.initState();
  //   getCurrentWeather(textcityController.text,textcountryController.text);
  // }

  Future<void> getCurrentWeather(String cityName, String country) async {
    try {
      setState(() {
        isLoding = true;
      });

      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,$country&APPID=$openWeatherApiKey'),
      );

      if (res.statusCode != 200) {
        throw 'An unexpected error occurred';
      }

      final data = jsonDecode(res.body);

      setState(() {
        temp = data['list'][0]['main']['temp'];
        sky = data['list'][0]['weather'][0]['main'];
        wind = data['list'][0]['wind']['speed'];
        humidity = data['list'][0]['main']['humidity'];
        pressure = data['list'][0]['main']['pressure'];
        isLoding = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }
  void _resetState() {
    setState(() {
      textcityController.clear();
      textcountryController.clear();
      temp = 273.15;
      sky = '';
      wind = 0;
      humidity = 0;
      pressure = 0;
      isLoding = false;
    });
  }
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;

    double val = temp - 273.15;
    return Scaffold(
      appBar: AppBar(

        title: const Text('Weather App'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            onPressed: _resetState,
            icon: const Icon(Icons.keyboard_backspace),
          ),
        ],
      ),
      // SizedBox(height: screenheight*0.1),
      body: isLoding
          ? const LinearProgressIndicator()
          : Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenheight * 0.01,
                  horizontal: screenwidth * 0.05),
              child: SingleChildScrollView(
                child: Column(children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter City Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: textcityController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        hintText: 'Enter City',
                        hintStyle: const TextStyle(
                          color: Colors.black26,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter Country Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: textcountryController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        hintText: 'Enter Country ',
                        hintStyle: const TextStyle(
                          color: Colors.black26,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                  SizedBox(
                    height: screenheight * 0.01,
                  ),
                  TextButton(
                    onPressed: () async {
                      String country = textcountryController.text;
                      String cityName = textcityController.text;
                           try{
                           getCurrentWeather(cityName, country);


                       }
                       catch (e){
                         // print('Failed to parse input:$e');
                         _showErrorDialog(e.toString());
                       }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(Checkbox.width, 40),
                    ),
                    child: const Text(
                      'Search',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: screenheight * 0.02),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Current Temperature',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenheight * 0.02,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: screenheight * 0.20,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: screenheight * 0.02,
                                ),
                                Text(
                                  '${val.toStringAsFixed(2)} C',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: screenheight * 0.001,
                                ),
                                Icon(
                                  sky == 'Clear' || sky == 'Cloud'
                                      ? Icons.sunny
                                      : Icons.cloud,
                                  size: 50,
                                  shadows: const [
                                    Shadow(offset: Offset.infinite),
                                  ],
                                ),
                                SizedBox(
                                  height: screenheight * 0.001,
                                ),
                                Text(
                                  sky,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: screenheight * 0.01,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Additional Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenheight * 0.02,
                        ),
                        Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: screenheight * 0.02,
                                  ),
                                  const Icon(
                                    Icons.water_drop,
                                    size: 40,
                                  ),
                                  SizedBox(height: screenheight * 0.01),
                                  const Text(
                                    'Humidity',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: screenheight * 0.01),
                                  Text(
                                    '$humidity',
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height: screenheight * 0.02),
                                  const Icon(
                                    Icons.air,
                                    size: 40,
                                  ),
                                  SizedBox(height: screenheight * 0.01),
                                  const Text(
                                    'Wind Speed',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: screenheight * 0.01),
                                  Text(
                                    '$wind',
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height: screenheight * 0.02),
                                  const Icon(
                                    Icons.umbrella,
                                    size: 40,
                                  ),
                                  SizedBox(height: screenheight * 0.01),
                                  const Text(
                                    'Pressure',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: screenheight * 0.01),
                                  Text(
                                    '$pressure',
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
    );
  }
}
