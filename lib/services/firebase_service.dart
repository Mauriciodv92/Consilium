import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Obtener todas las publicaciones activas y ordenadas por fecha de forma descendente
Future<List<Map<String, dynamic>>> getPublish() async {
  List<Map<String, dynamic>> publish = [];

  CollectionReference collectionReferencePublish = db.collection('Publication');

  QuerySnapshot queryPublish = await collectionReferencePublish
      .where('activo', isEqualTo: 1) // Filtra solo las publicaciones activas
      .orderBy('dueDate', descending: false) // Ordena por la fecha en orden descendente
      .get();

  queryPublish.docs.forEach((documento) {
    Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    data['id'] = documento.id; // Agrega el documentId a los datos
    publish.add(data);
  });

  return publish;
}

// Función para agregar un nuevo asunto
Future<void> addPublish(Map<String, dynamic> newIssue) async {
  try {
    CollectionReference collectionReferencePublish = db.collection('Publication');
    newIssue['activo'] = 1; // Activo por defecto al crear un nuevo asunto
    await collectionReferencePublish.add(newIssue);
  } catch (e) {
    print("Error al agregar asunto: $e");
  }
}

// Función para actualizar un asunto existente
Future<void> updatePublish(String documentId, Map<String, dynamic> updatedIssue) async {
  try {
    CollectionReference collectionReferencePublish = db.collection('Publication');
    await collectionReferencePublish.doc(documentId).update(updatedIssue);
    print("Asunto actualizado correctamente: $documentId");
  } catch (e) {
    print("Error al actualizar el asunto: $e");
  }
}

// Función para obtener un asunto específico por su documentId
Future<DocumentSnapshot> getPublishById(String documentId) {
  return db.collection('Publication').doc(documentId).get();
}

// Función para inactivar un asunto
Future<void> inactivateIssue(String documentId) async {
  try {
    CollectionReference collectionReferencePublish = db.collection('Publication');
    
    await collectionReferencePublish.doc(documentId).update({'activo': 2});
    
    // Confirmación de que se ha realizado la actualización
    print("Asunto inactivado correctamente: $documentId");
  } catch (e) {
    // Mensaje de error con detalles
    print("Error al inactivar el asunto: $e");
  }
}

Future<void> accomplishedIssue(String documentId) async {
  try {
    CollectionReference collectionReferencePublish = db.collection('Publication');
    
    await collectionReferencePublish.doc(documentId).update({'activo': 3});
    
    // Confirmación de que se ha realizado la actualización
    print("Asunto marcado como cumplido correctamente: $documentId");
  } catch (e) {
    // Mensaje de error con detalles
    print("Error al marcar como cumplido el asunto: $e");
  }
}

// Nueva función para obtener asuntos dentro de un rango de fechas y con un filtro de estado
Future<List<Map<String, dynamic>>> getAsuntosByDateRange(
  DateTime startDate,
  DateTime endDate,
  int estado,
) async {
  final CollectionReference collection = FirebaseFirestore.instance.collection('Publication');
  
  QuerySnapshot querySnapshot = await collection
    .where('activo', isEqualTo: estado) // Filtra por estado
    .where('dueDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate)) // Fecha de inicio
    .where('dueDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate)) // Fecha de fin
    .get();
  
  // Mapea los resultados para incluir el ID del documento en el mapa de datos
  return querySnapshot.docs
    .map((doc) => {
      'id': doc.id,
      ...doc.data() as Map<String, dynamic> // Combina los datos del documento con el ID
    })
    .toList();
}


