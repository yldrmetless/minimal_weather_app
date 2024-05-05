import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const baseURL = "https://api.openweathermap.org/data/2.5/weather";
  final String apikey;

  WeatherService(this.apikey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$baseURL?q=$cityName&appid=$apikey&units=metric'));

    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Failed to load weather data");
    }
  }

  Future<String> getCurrentCity() async {
  try {
    //get permission from user
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    //convert the location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    //extract the city name from the first placemark
    String? city = placemarks.isNotEmpty ? placemarks[0].locality : null;

    if (city != null) {
      return city;
    } else {
      throw Exception("Placemark does not contain locality information");
    }
  } catch (e) {
    print("Error in getCurrentCity: $e");
    throw Exception("Failed to get current city: $e");
  }
}
}