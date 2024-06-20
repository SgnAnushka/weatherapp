import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firstpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class mainpage extends StatefulWidget {
  const mainpage({super.key});

  @override
  State<mainpage> createState() => _mainpageState();
}

class _mainpageState extends State<mainpage> {
  var searchController = TextEditingController();
  Map<String, dynamic> _weatherData = {};
  bool _isLoading = false;
  String? _errorMessage;
  late String _cityName;

  @override
  void initState() {
    super.initState();
    fetchUserLocationWeather();
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        title:Row(
          children: [
            Icon(Icons.cloud_sharp, color: Colors.black), // Example icon
            SizedBox(width: 8), // Adjust spacing between icon and text
            Text('$_cityName', style: TextStyle(color: Colors.black87,fontSize: 30)),
          ],
        ),/*  Text('Weather for: $_cityName', style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold)),*/
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[400],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Search location',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await fetchWeather(searchController.text);
                  },
                  child: const Text('SEARCH'),
                ),
                const SizedBox(height: 20),
                if (_isLoading) const CircularProgressIndicator(),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                if (_weatherData.isNotEmpty && _errorMessage == null)


    Expanded(
    child: ListView(
    children: [
     Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(
      height: 400,
    decoration: BoxDecoration(

    borderRadius: BorderRadius.circular(20.0),
    color: Colors.black87,
    ),
    child: Center(
    child:Column(

      children: [
      Text(' $_cityName',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
      ),
    ),
      SizedBox(height: 5),
      Text(' ${_weatherData['temp']}°C',
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          color: Colors.blue,
          fontSize: 60,
        ),
      ),
        SizedBox(height: 10),
        Text(' ${_weatherData['weather']}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        SizedBox(height: 10),
        Text('Feels like: ${_weatherData['feels_like']}°C',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),

    ]),
    ),
     ),
    ),
    Padding(
     padding: EdgeInsets.all(8.0),

    child:Container(
      height: 100,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20.0),
    color: Colors.black87,
    ),
    child: Center(
    child: Text('Max/Min: ${_weatherData['temp_max']}°/${_weatherData['temp_min']}°',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
    ),
    ),
    ),


    ),


    Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(
      height: 100,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20.0),
    color: Colors.black87,
    ),
    child: Center(
    child: Text(
    'Humidity: ${_weatherData['humidity']}%',
    style: const TextStyle(
    color: Colors.white,
    fontSize: 25,
    ),
    ),
    ),
    ),
    ),
    Padding(
    padding:EdgeInsets.all(8.0),
    child: Container(
      height: 100,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20.0),
    color: Colors.black87,
    ),
    child: Center(
    child: Text(
    'Wind Speed: ${_weatherData['wind_speed']}m/sec',
    style: const TextStyle(
    color: Colors.white,
    fontSize: 25,
    ),
    ),
    ),
    ),
    ),
    Padding(
    padding: EdgeInsets.all(8.0),
    child: Container(
      height: 100,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20.0),
    color: Colors.black87,
    ),
    child: Center(
    child: Column(
      children: [
        Text('Sea level: ${_weatherData['sea_level']}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        SizedBox(height: 20),
        Text('Ground lvl: ${_weatherData['grnd_level']}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),

    ],
    ),
    ),
    ),
    ),

    Padding(
    padding:EdgeInsets.all(8.0),
    child: Container(
      height: 100,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20.0),
    color: Colors.black87,
    ),
    child: Center(
    child: Text(
    'Air Pressure: ${_weatherData['pressure']}hPa',
    style: const TextStyle(
    color: Colors.white,
    fontSize: 20,
    ),
    ),
    ),
    ),
    ),






    ],
    ),
    ),







    ]
            ),
    ))
    ));


  }
  Future<String> whichcity() async {
    String cityName;
    if (searchController.text.isNotEmpty) {
      cityName = searchController.text;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? credentials = prefs.getStringList('Credentials');
      if (credentials != null && credentials.isNotEmpty) {
        cityName = credentials[1];
      } else {
        cityName = 'Guwahati';
      }
    }
    return cityName;

  }
  Future<void> fetchUserLocationWeather() async {
    String cityName = await whichcity();
    await fetchWeather(cityName);
    setState(() {
      _cityName = cityName;
    });
  }


  Future<void> fetchWeather(String cityName) async {
    String cityName=await whichcity();

    setState(() {
      _isLoading = true;
      _weatherData = {};
      _errorMessage = null;
      _cityName = cityName;

    });

    try {
      final coordinates = await fetchCoordinates(cityName);
      if (coordinates != null) {
        final lat = coordinates['lat'];
        final lon = coordinates['lon'];
        if (lat != null && lon != null) {
          await fetchWeatherData(lat, lon);
        } else {
          throw Exception('Failed to get valid coordinates for city: $cityName');
        }
      } else {
        throw Exception('Failed to get coordinates for city: $cityName');
      }
    } catch (error) {
      print('Error fetching weather data: $error');
      setState(() {
        _errorMessage = 'Error fetching weather data: $error';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<Map<String, double>?> fetchCoordinates(String cityName) async {
    final apiKey = 'b710f78807883ffa98a9454ce7ea5b5b';
    final url = Uri.parse('http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=1&appid=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = data[0]['lat'] as double?;
          final lon = data[0]['lon'] as double?;
          if (lat != null && lon != null) {
            return {'lat': lat, 'lon': lon};
          } else {
            return null;
          }
        } else {
          return null;
        }
      } else {
        print('Failed to load coordinates: ${response.reasonPhrase}');
        return null;
      }
    } catch (error) {
      print('Error fetching coordinates: $error');
      return null;
    }
  }


  Future<void> fetchWeatherData(double lat, double lon) async {
    final apiKey = 'b710f78807883ffa98a9454ce7ea5b5b';
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherData = {
            'temp': data['main']['temp'],
            'weather': data['weather'][0]['description'],
            'humidity': data['main']['humidity'],
            'wind_speed': data['wind']['speed'],
            'feels_like': data['main']['feels_like'],
            'pressure': data['main']['pressure'],
            'sea_level': data['main']['sea_level'],
            'grnd_level': data['main']['grnd_level'],
            'temp_min': data['main']['temp_min'],
            'temp_max': data['main']['temp_max'],
            'visibility': data['visibility'],
            'sunrise': data['sys']['sunrise'],

          };
        });
      } else {
        print('Failed to load weather data: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching weather data: $error');
    }
  }

  Future<void> logout() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      prefs.setBool(MyHomePageState.KEY, false);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const firstpage()));
    } catch (e) {
      print('Error logging out: $e');
    }
  }


}


/*
{
  "coord": {
    "lon": 10.99,
    "lat": 44.34
  },
  "weather": [
    {
      "id": 501,
      "main": "Rain",
      "description": "moderate rain",
      "icon": "10d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 298.48,
    "feels_like": 298.74,
    "temp_min": 297.56,
    "temp_max": 300.05,
    "pressure": 1015,
    "humidity": 64,
    "sea_level": 1015,
    "grnd_level": 933
  },
  "visibility": 10000,
  "wind": {
    "speed": 0.62,
    "deg": 349,
    "gust": 1.18
  },
  "rain": {
    "1h": 3.16
  },
  "clouds": {
    "all": 100
  },
  "dt": 1661870592,
  "sys": {
    "type": 2,
    "id": 2075663,
    "country": "IT",
    "sunrise": 1661834187,
    "sunset": 1661882248
  },
  "timezone": 7200,
  "id": 3163858,
  "name": "Zocca",
  "cod": 200
}
                        */