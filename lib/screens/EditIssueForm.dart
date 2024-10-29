import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:feedcards/services/firebase_service.dart';

class EditIssueForm extends StatefulWidget {
  final String documentId; // ID del documento
  final String name; // Nombre del asunto
  final String description; // Descripción del asunto
  final DateTime? dueDate; // Fecha de vencimiento
  final String priority; // Prioridad
  final String specialty; // Especialidad

  const EditIssueForm({
    Key? key,
    required this.documentId,
    required this.name,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.specialty,
  }) : super(key: key);

  @override
  _EditIssueFormState createState() => _EditIssueFormState();
}

class _EditIssueFormState extends State<EditIssueForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  DateTime? dueDate;
  String priority = 'Baja'; // Valor predeterminado
  String specialty = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inicializar los campos del formulario con los valores existentes
    name = widget.name;
    description = widget.description;
    dueDate = widget.dueDate;
    priority = widget.priority.isNotEmpty ? widget.priority : 'Baja'; // Asegurarse de que tenga un valor válido
    specialty = widget.specialty;
  }

  // Función para abrir el selector de fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  // Función para abrir el selector de hora
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dueDate ?? DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        dueDate = DateTime(
          dueDate?.year ?? DateTime.now().year,
          dueDate?.month ?? DateTime.now().month,
          dueDate?.day ?? DateTime.now().day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Asunto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.title),
                ),
                initialValue: name,
                onSaved: (value) {
                  name = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description),
                ),
                initialValue: description,
                onSaved: (value) {
                  description = value ?? '';
                },
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text(
                  dueDate == null
                      ? 'Seleccione fecha de vencimiento'
                      : 'Fecha de vencimiento: ${dueDate!.toLocal()}'.split(' ')[0],
                ),
                leading: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text(
                  dueDate == null
                      ? 'Seleccione hora de vencimiento'
                      : 'Hora de vencimiento: ${dueDate!.hour}:${dueDate!.minute.toString().padLeft(2, '0')}',
                ),
                leading: Icon(Icons.access_time),
                onTap: () => _selectTime(context),
              ),
              DropdownButtonFormField<String>(
                value: priority,
                decoration: const InputDecoration(
                  labelText: 'Prioridad',
                  prefixIcon: Icon(Icons.priority_high),
                ),
                items: ['Baja', 'Media', 'Alta'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    priority = newValue ?? 'Baja'; // Valor por defecto
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione una prioridad';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Especialidad',
                  prefixIcon: Icon(Icons.work),
                ),
                initialValue: specialty,
                onSaved: (value) {
                  specialty = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Map<String, dynamic> issueData = {
                      'name': name,
                      'description': description,
                      'dueDate': dueDate,
                      'priority': priority,
                      'specialty': specialty,
                    };
                    // Aquí debes llamar al método de actualización, asegurándote de tenerlo disponible
                    updatePublish(widget.documentId, issueData);
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

