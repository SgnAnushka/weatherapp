import 'package:flutter/material.dart';
import 'mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firstpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[400],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const String KEY = "login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[400],
        child: Center(
          child: ElevatedButton(
            onPressed: wheretogo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[100],
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('START'),
          ),
        ),
      ),
    );
  }

  void wheretogo() async {
    try {
      var sharedPref = await SharedPreferences.getInstance();
      var isLoggedin = sharedPref.getBool(KEY);

      if (isLoggedin != null) {
        if (isLoggedin) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const mainpage()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const firstpage()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const firstpage()));
      }
    } catch (e) {
      print("ERROR:$e");
    }
  }
}
