import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:feedcards/services/firebase_service.dart';

class NewIssueForm extends StatefulWidget {
  const NewIssueForm({super.key});

  @override
  _NewIssueFormState createState() => _NewIssueFormState();
}

class _NewIssueFormState extends State<NewIssueForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  DateTime? dueDate;
  String priority = 'Baja';
  String specialty = '';
  bool isLoading = false;

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
        // Actualiza la hora en la fecha seleccionada
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
        title: const Text('Nuevo Asunto'),
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
                leading: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text(
                  dueDate == null
                      ? 'Seleccione hora de vencimiento'
                      : 'Hora de vencimiento: ${TimeOfDay.fromDateTime(dueDate!).format(context)}',
                ),
                leading: const Icon(Icons.access_time),
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
                    priority = newValue ?? 'Baja';
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Especialidad',
                  prefixIcon: Icon(Icons.work),
                ),
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
                    addPublish(issueData); // Método para agregar un nuevo asunto
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

