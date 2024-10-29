import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:feedcards/widgets/card.dart'; // Asegúrate de importar tu archivo de tarjetas

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DateTimeRange? selectedDateRange; // Rango de fechas seleccionado
  List<Map<String, dynamic>> asuntos = []; // Lista de asuntos
  int? selectedEstado; // Estado seleccionado (1: Activo, 2: Eliminado, 3: Cumplido, 4: Vencido)

  // Función para mostrar el DateRangePicker
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year, now.month - 1, now.day), // Rango de un mes
      lastDate: DateTime(now.year, now.month + 3, now.day), // Permitir hasta 3 meses más
      initialDateRange: selectedDateRange ?? DateTimeRange(
        start: now.subtract(Duration(days: 7)),
        end: now,
      ),
    );

    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
      });
      _getAsuntosByDateRangeAndEstado(picked.start, picked.end, selectedEstado); // Cargar asuntos
    }
  }

  // Función para obtener los asuntos dentro del rango de fechas y estado seleccionado
  Future<void> _getAsuntosByDateRangeAndEstado(DateTime startDate, DateTime endDate, int? estado) async {
    try {
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('Publication');

      Query query = collectionReference
          .where('dueDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('dueDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate));

      // Solo añadir el filtro de estado si se ha seleccionado uno
      if (estado != null) {
        query = query.where('activo', isEqualTo: estado); // Filtrar por estado
      }

      // Obtener los documentos de Firestore que cumplen con los filtros
      QuerySnapshot querySnapshot = await query.get();

      // Procesar los documentos obtenidos y crear una lista
      List<Map<String, dynamic>> asuntosList = querySnapshot.docs.map((doc) {
        return {
          ...doc.data() as Map<String, dynamic>,
          'id': doc.id, // Agregar el ID del documento
        };
      }).toList();

      setState(() {
        asuntos = asuntosList; // Actualizar la lista de asuntos
      });
    } catch (e) {
      print('Error al obtener asuntos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reportes de Asuntos por Fechas'),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () => _selectDateRange(context), // Seleccionar rango de fechas
          ),
        ],
      ),
      body: Column(
        children: [
          if (selectedDateRange != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Asuntos desde ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} hasta ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          // Dropdown para seleccionar el estado
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<int>(
              hint: Text("Selecciona un estado"),
              value: selectedEstado,
              onChanged: (int? newValue) {
                setState(() {
                  selectedEstado = newValue;
                });
                // Filtrar de nuevo con el nuevo estado
                if (selectedDateRange != null) {
                  _getAsuntosByDateRangeAndEstado(selectedDateRange!.start, selectedDateRange!.end, selectedEstado);
                }
              },
              items: [
                DropdownMenuItem(value: 1, child: Text("Activos")),
                DropdownMenuItem(value: 2, child: Text("Eliminados")),
                DropdownMenuItem(value: 3, child: Text("Cumplidos")),
                DropdownMenuItem(value: 4, child: Text("Vencidos")),
              ],
            ),
          ),
          Expanded(
            child: asuntos.isEmpty
                ? Center(
                    child: Text('No hay asuntos en el rango de fechas y estado seleccionado'),
                  )
                : ListView.builder(
                    itemCount: asuntos.length,
                    itemBuilder: (context, index) {
                      final asunto = asuntos[index];
                      return card(
                        data: asunto,
                        documentId: asunto['id'], // Pasar el ID del documento
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}






