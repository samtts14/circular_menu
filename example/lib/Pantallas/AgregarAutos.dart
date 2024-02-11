import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(Agregarvehiculo());
}

class Agregarvehiculo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CarPhoneListScreen(),
    );
  }
}

class CarPhoneListScreen extends StatefulWidget {
  @override
  _CarPhoneListScreenState createState() => _CarPhoneListScreenState();
}

class _CarPhoneListScreenState extends State<CarPhoneListScreen> {
  List<String> carNames = [];
  List<String> phoneNumbers = [];

  TextEditingController carNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  bool showingForm = false;

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
        title: Text('Administrar autos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: carNames.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(carNames[index]),
                        subtitle: Text(phoneNumbers[index]),
                        onTap: () {
                          // Implementar cualquier acción cuando se seleccione un elemento en la lista.
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _editCar(index);
                              },
                              icon: Icon(Icons.edit),
                              color: Colors.amber,
                            ),
                            IconButton(
                              onPressed: () {
                                _confirmDeleteCar(index);
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red.shade800,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ],
                  );
                },
              ),
            ),
            if (showingForm) ...[
              TextField(
                controller: carNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.red.shade50,
                  labelText: 'Nombre de vehiculo',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.red.shade50,
                  labelText: 'Numero de GPS',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0), // Ajuste del tamaño horizontal
                      shape: StadiumBorder(),
                      shadowColor: Colors.red.shade100,
                      primary: Colors.red, // Cambio del color del botón a rojo
                    ),
                    onPressed: () {
                      if (carNameController.text.isNotEmpty && phoneNumberController.text.isNotEmpty) {
                        setState(() {
                          carNames.add(carNameController.text);
                          phoneNumbers.add(phoneNumberController.text);
                          carNameController.clear();
                          phoneNumberController.clear();
                          saveData(); // Guardar los datos en SharedPreferences
                          showingForm = false;
                          showSnackbar('Se ha agregado un nuevo auto');
                        });
                      } else {
                        showSnackbar('Por favor, ingrese un nombre y un número de GPS.');
                      }
                    },
                    child: Text('Agregar auto'),
                  ),
                ],
              ),
            ],
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  showingForm = !showingForm; // Alternar el estado de showingForm
                });
              },
              child: Icon(showingForm ? Icons.close : Icons.add), // Cambiar el icono según el estado
              backgroundColor: Color.fromARGB(255, 233, 61, 61),
            ),
          ],
        ),
      ),
    );
  }

  // Guardar datos en SharedPreferences
  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('carNames', carNames);
    prefs.setStringList('phoneNumbers', phoneNumbers);
  }

  // Cargar datos desde SharedPreferences
  void loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      carNames = prefs.getStringList('carNames') ?? [];
      phoneNumbers = prefs.getStringList('phoneNumbers') ?? [];
    });
  }

  // Editar un auto en la lista
  void _editCar(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar vehículo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: carNames[index]),
                onChanged: (value) {
                  carNames[index] = value;
                },
                decoration: InputDecoration(labelText: 'Nombre del vehiculo'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: TextEditingController(text: phoneNumbers[index]),
                onChanged: (value) {
                  phoneNumbers[index] = value;
                },
                decoration: InputDecoration(labelText: 'Numero de GPS'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  saveData();
                });
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Eliminar un auto de la lista
  void _deleteCar(int index) {
    setState(() {
      carNames.removeAt(index);
      phoneNumbers.removeAt(index);
      saveData();
    });
  }

  // Mostrar un diálogo de confirmación antes de eliminar un auto
  void _confirmDeleteCar(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar vehículo'),
          content: Text('¿Estás seguro que deseas eliminar este vehículo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _deleteCar(index);
                Navigator.pop(context);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar el Snackbar
  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
