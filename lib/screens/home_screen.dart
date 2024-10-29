import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedcards/Data/data.dart';
import 'package:feedcards/screens/NewIssueForm.dart';
import 'package:feedcards/screens/calendar_screen.dart';
import 'package:feedcards/screens/profile_screen.dart';
import 'package:feedcards/screens/settings.dart';
import 'package:feedcards/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:feedcards/widgets/listcard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _paginaActual = 0;
  List<Map<String, dynamic>> listData = []; // Declaración de listData

  List<Widget> _paginas = [
    const ListCard(),
    const ProfileScreen(),
    const CalendarScreen(),
    const SettingsScreen(),
  ];

  // Para manejar la actualización de la lista
  void refreshList() async {
    // Llamar al servicio de Firebase para obtener los datos actualizados
    final updatedList =
        await getPublish(); // Reemplaza con tu función para obtener datos
    setState(() {
      // Actualizar los datos que se muestran en la UI
      listData = updatedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo11.PNG', // Ruta de tu logo
              height: 40, // Ajusta el tamaño según sea necesario
            ),
            const SizedBox(width: 8), // Espacio entre el logo y el texto
            const Text('Consilium'), // Texto del título
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
      ),
      body: _paginaActual == 0 // Solo en la primera página
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Alinear el texto a la izquierda
              children: [
                // Este título se mostrará solo en HomeScreen
                Padding(
                  padding: const EdgeInsets.all(16.0), // Espaciado alrededor del texto
                  child: const Text(
                    'Asuntos pendientes:', // Título añadido
                    style: TextStyle(
                      fontSize: 20, // Tamaño de fuente
                      fontWeight: FontWeight.normal, // Negrita
                      color: Colors.black, // Color del texto
                    ),
                  ),
                ),
                Expanded(child: _paginas[_paginaActual]), // ListCard(), // La lista de publicaciones
              ],
            )
          : _paginas[_paginaActual], // Para las otras páginas
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Abrimos el formulario y esperamos el resultado
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewIssueForm()),
          );

          // Si el resultado es "true", recargar la lista
          if (result == true) {
            refreshList(); // Llama a setState para recargar la lista
          }
        },
        child: const Icon(Icons.add), // Icono del botón flotante
        backgroundColor: Color.fromARGB(255, 0, 0, 0), // Color del botón
        foregroundColor: Colors.white, // Color del ícono dentro del botón
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _paginaActual = index;
          });
        },
        currentIndex: _paginaActual,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Reportes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Calendario'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuración')
        ],
        backgroundColor: const Color.fromARGB(255, 255, 252, 252),
        selectedItemColor: Color.fromARGB(255, 173, 124, 0),
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
