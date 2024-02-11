import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(Localizar());
}

class Localizar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocalizarScreen(),
    );
  }
}

class LocalizarScreen extends StatefulWidget {
  @override
  _LocalizarScreenState createState() => _LocalizarScreenState();
}

class _LocalizarScreenState extends State<LocalizarScreen> {
  List<String> carNames = [];
  List<String> phoneNumbers = [];
  List<bool> carStates = [];
  int selectedVehicleIndex = -1;

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 233, 61, 61),
        title: Text('Localizar Vehículos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: carNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(carNames[index]),
                  subtitle: Text(phoneNumbers[index]),
                  leading: Icon(
                    carStates[index] ? Icons.power_settings_new : Icons.power_off,
                    color: carStates[index] ? Colors.green : Colors.red,
                  ),
                  tileColor: index == selectedVehicleIndex ? Color.fromARGB(255, 233, 61, 61).withOpacity(0.1) : null,
                  onTap: () {
                    setState(() {
                      selectedVehicleIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
    Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            shape: StadiumBorder(),
            shadowColor: Colors.red.shade100,
            primary: Colors.green, 
            side: BorderSide(color: Colors.green),
            elevation: 5, // Ajusta el valor de elevación aquí
          ),
          onPressed: selectedVehicleIndex != -1 ? _localizarVehiculo : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.power_settings_new), // Icono para encender
              SizedBox(width: 10), // Espacio entre el icono y el texto
              Text('Localizar'),
            ],
          ),
        ),
        SizedBox(height: 35), // Espacio entre los botones
        
         // Espacio debajo del botón "Apagar"
      ],
    ),
  ],
          ),
        ],
      ),
    
    );
  }

  void loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      carNames = prefs.getStringList('carNames') ?? [];
      phoneNumbers = prefs.getStringList('phoneNumbers') ?? [];
      carStates = List.generate(carNames.length, (index) => prefs.getBool('carState$index') ?? false);
    });
  }

  void _localizarVehiculo() {
    setState(() {
      carStates[selectedVehicleIndex] = true;
    });
    String phoneNumber = phoneNumbers[selectedVehicleIndex];
    String message = "fix030s005n123456";
    _sendSMS(phoneNumber, message);
    saveState();
  }

  void _sendSMS(String phoneNumber, String message) async {
    String url = 'sms:$phoneNumber?body=$message';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo enviar el SMS a $phoneNumber';
    }
  }

  void saveState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < carNames.length; i++) {
      prefs.setBool('carState$i', carStates[i]);
    }
  }

  

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('carNames', carNames);
    prefs.setStringList('phoneNumbers', phoneNumbers);
  }
}
