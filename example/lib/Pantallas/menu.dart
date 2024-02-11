import 'package:CarFounded/Pantallas/AlarmadePuerta.dart';
import 'package:CarFounded/Pantallas/EncendidoAutos.dart';
import 'package:CarFounded/Pantallas/Localizacion.dart';
import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:CarFounded/Pantallas/AgregarAutos.dart';
import 'package:CarFounded/Pantallas/ApagarEncender.dart';

class MenuPrincipal extends StatefulWidget {
  @override
  _MenuPrincipalState createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  //String _colorName = 'No';
  Color _color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
         backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 233, 61, 61),
          title: Text('Menu'),
        ),
        body: CircularMenu(
          alignment: Alignment.bottomCenter,
          backgroundWidget: Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 28),
                children: <TextSpan>[
                  TextSpan(
                    //text: _colorName,
                    style: TextStyle(color: _color, fontWeight: FontWeight.bold),
                  ),
                  //TextSpan(text: ' button is clicked.'),
                ],
              ),
            ),
          ),
          toggleButtonColor: Color.fromARGB(255, 233, 61, 61),
          items: [//AVISO DE ENCENDIDO DE MOTOR
            CircularMenuItem(
              icon: Icons.notifications_active,
              color: Color.fromARGB(255, 194, 8, 147),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlarmaEncendido()),
                );
              },
            ),//LOCALIZAR AUTOS
            CircularMenuItem(
              icon: Icons.location_on,
              color: Color.fromARGB(255, 34, 170, 34),
              onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocalizarScreen()),
                );
              },
            ),//ALARMA DE PUERTAS
            CircularMenuItem(
              icon: Icons.meeting_room,
              color: Color.fromARGB(255, 7, 137, 146),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AlarmaDePuertas()),
                );
              },
            ),//APAGAR Y ENCENDER AUTOS
            CircularMenuItem(
              icon: Icons.power_settings_new,
              color: Color.fromARGB(255, 214, 87, 14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApagarEncenderScreen()),
                );
              },
            ),//AGREGAR AUTOS
            CircularMenuItem(
              icon: Icons.directions_car_outlined,
              color: Color.fromARGB(255, 46, 28, 202),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Agregarvehiculo()), // Navega a la pantalla Agregarvehiculo
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
