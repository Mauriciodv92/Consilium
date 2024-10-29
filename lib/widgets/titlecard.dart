import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedcards/screens/EditIssueForm.dart';
import 'package:feedcards/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Agrega esta línea

class Titlecard extends StatelessWidget {
  const Titlecard({
    super.key,
    required this.name,
    required this.documentId,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.specialty,
  });

  final String name; // Nombre del asunto
  final String documentId; // ID del asunto
  final String description; // Descripción del asunto
  final DateTime? dueDate;   // Fecha de vencimiento
  final String priority;     // Prioridad
  final String specialty;    // Especialidad

  @override
  Widget build(BuildContext context) {
    // Formato de fecha y hora
    String formattedDateTime = dueDate != null 
        ? DateFormat('yyyy-MM-dd HH:mm').format(dueDate!) 
        : 'Sin fecha';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          child: Text("A"), // Personaliza esto según sea necesario
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 22, 22, 22),
                ),
              ),
              Text(
                formattedDateTime,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            // Llama al método getPublishById para obtener los datos
            final issueData = await getPublishById(documentId);
            
            // Verifica si se obtuvieron los datos correctamente
            if (issueData != null) {
              // Navega al formulario de edición pasando los datos obtenidos
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditIssueForm(
                    documentId: documentId,
                    name: issueData['name'],
                    description: issueData['description'],
                    dueDate: (issueData['dueDate'] as Timestamp?)?.toDate(), // Convierte Timestamp a DateTime
                    priority: issueData['priority'],
                    specialty: issueData['specialty'],
                  ),
                ),
              );

              // Puedes manejar el resultado aquí si es necesario
              if (result != null) {
                // Actualiza la UI o realiza acciones si es necesario
              }
            } else {
              // Manejar el caso en que no se obtienen datos
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al obtener los datos del asunto.')),
              );
            }
          },
          child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.edit, color: Colors.black),
          ),
        ),
      ],
    );
  }
}






