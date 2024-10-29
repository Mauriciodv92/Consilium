import 'package:feedcards/services/firebase_service.dart'; // Asegúrate de que la ruta sea correcta
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BottomsCard extends StatefulWidget {
  const BottomsCard({
    super.key,
    required this.documentId, // Se requiere el ID del documento
  });

  final String documentId; // ID del documento en Firebase

  @override
  _BottomsCardState createState() => _BottomsCardState();
}

class _BottomsCardState extends State<BottomsCard> {
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.grey, 
      fontSize: 16, 
      fontWeight: FontWeight.bold,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () async {
            // Confirmación antes de marcar como cumplido
            final bool? shouldAccomplish = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirmar acción"),
                  content: const Text("¿Estás seguro de que deseas marcar este asunto como cumplido?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Cumplido"),
                    ),
                  ],
                );
              },
            );

            if (shouldAccomplish == true) {
              // Llamar a la función para marcar el asunto como cumplido desde el servicio Firebase
              await accomplishedIssue(widget.documentId);
              setState(() {}); // Actualiza la interfaz después de marcar como cumplido
            }
          },
          child: const Text(
            "Cumplido",
            style: textStyle,
          ),
        ),
        TextButton(
          onPressed: () async {
            // Confirmación antes de eliminar
            final bool? shouldDelete = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirmar eliminación"),
                  content: const Text("¿Estás seguro de que deseas eliminar este asunto?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Eliminar"),
                    ),
                  ],
                );
              },
            );

            if (shouldDelete == true) {
              // Llamar a la función para eliminar el asunto desde el servicio Firebase
              await inactivateIssue(widget.documentId);
              setState(() {}); // Actualiza la interfaz después de eliminar
            }
          },
          child: const Text(
            "Eliminar",
            style: textStyle,
          ),
        ),
      ],
    );
  }
}



