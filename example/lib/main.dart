import 'package:flutter/material.dart';

import 'Pantallas/menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MenuPrincipal(),
    );
  }
}


