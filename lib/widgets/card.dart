import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedcards/widgets/bottomscard.dart';
import 'package:feedcards/widgets/descriptioncard.dart';
import 'package:feedcards/widgets/titlecard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Agrega esta línea

class card extends StatelessWidget { // Cambié el nombre de la clase a `CardWidget` por convención
  const card({super.key, required this.data, required this.documentId});

  final Map<String, dynamic> data; // Map con los datos de la publicación
  final String documentId; // El ID del documento en Firebase

  @override
  Widget build(BuildContext context) {
    // Formateo de la fecha y la hora
    String formattedDueDate = data["dueDate"] != null 
        ? DateFormat('yyyy-MM-dd HH:mm').format((data["dueDate"] as Timestamp).toDate()) 
        : "No especificada";

    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del asunto
          Container(
            padding: const EdgeInsets.all(10),
            child: Titlecard(
              name: data["name"] ?? "Sin nombre", // Cambié el campo a "name"
              documentId: documentId, // Usar el documentId proporcionado
              description: '', 
              dueDate: (data["dueDate"] as Timestamp?)?.toDate(), // Pasar DateTime
              priority: data["priority"] ?? '', 
              specialty: data["specialty"] ?? '',
            ),
          ),
          
          // Descripción del asunto
          descriptioncard(
              description: data["description"] ?? "Sin descripción"), // Asegúrate de que la clase se llame DescriptionCard

          // Nueva sección: Fecha de vencimiento
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Fecha de vencimiento: $formattedDueDate",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),

          // Nueva sección: Prioridad y Especialidad
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              "Prioridad: ${data["priority"] ?? "No especificada"} | Especialidad: ${data["specialty"] ?? "No especificada"}",
              style: TextStyle(fontSize: 14),
            ),
          ),

          // Sección inferior (botones o interacciones adicionales)
          Container(
            child: BottomsCard(documentId: documentId), // Corregido para pasar el documentId
          ),
        ],
      ),
    );
  }
}


