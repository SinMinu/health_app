import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String _cityName = "Seoul";
  String _weatherInfo = "No data";

  final String _apiKey = 'c490e92cf673bc89794d9e320ef38fb2'; // OpenWeatherMap에서 발급받은 API Key를 여기에 입력하세요.

  Future<void> _fetchWeather() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$_cityName&appid=$_apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _weatherInfo = "Temperature in $_cityName: ${data['main']['temp']}°C";
      });
    } else {
      // 상태 코드와 응답을 출력하여 문제를 진단
      print('Failed to load weather data. Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      setState(() {
        _weatherInfo = "Failed to load weather data";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _cityName = value;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: const Text('Get Weather'),
            ),
            const SizedBox(height: 16),
            Text(
              _weatherInfo,
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
