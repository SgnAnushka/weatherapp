import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mainpage.dart';
import 'main.dart';

class firstpage extends StatefulWidget {
  const firstpage({super.key});

  @override
  State<firstpage> createState() => firstpageState();
}

class firstpageState extends State<firstpage> {
  var nameController = TextEditingController();
  var locController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        title: Text(' USER LOG IN'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle_outlined, color: Colors.blue,
              size: 100,
                  ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(

                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: locController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Location',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  var prefs = await SharedPreferences.getInstance();
                  List<String> credentials = [
                    nameController.text.toString(),
                    locController.text.toString()
                  ];
                  prefs.setStringList('Credentials', credentials);
                  prefs.setBool(MyHomePageState.KEY, true);
                  if ((nameController.text.isNotEmpty) && (locController.text.isNotEmpty)) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => mainpage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter the values!',
                        style:TextStyle(
                        color: Colors.red,
                        ),),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: const Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getValue() async {
    var prefs = await SharedPreferences.getInstance();
    List<String>? credentials = prefs.getStringList('Credentials');
    if (credentials != null && credentials.length == 2) {
      nameController.text = credentials[0];
      locController.text = credentials[1];
    }
    setState(() {});
  }
}
