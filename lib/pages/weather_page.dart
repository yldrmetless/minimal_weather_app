import 'package:flutter/material.dart';
import 'package:minimal_weather_app/models/weather_model.dart';
import 'package:minimal_weather_app/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key
  final _weatherService = WeatherService("f0d961fe0b46dc3b1c10543fca5ee6d7");
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get the current api
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }catch(e){
      print(e);
    }
  }

  //weather animation
  String getWeatherAnimation(String? mainCondition){
    if(mainCondition == null ) return "assets/sunny.json"; //default to sunny

    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default: 
        return 'assets/sunny.json';

    }
  }

  @override
  void initState(){
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? "loading city.."),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            //temperature
            Text("${_weather?.temperature.round()}°C"),

            //weather condition
            Text(_weather?.mainCondition ?? ""),
          ]
        ),
      )
    );
  }
}