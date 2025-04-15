import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> add(String name, String degree) async {
    try {
      await _firestore.collection('user').add({
        "name": name,
        "degree": degree,
        "createdAt": FieldValue.serverTimestamp(), // Good practice to add timestamps
      });
      print("Success");
    } catch (e) {
      print("Error: ${e.toString()}");
      rethrow; // Better to rethrow so UI can handle errors
    }
  }

  Future<void> delete(String id) async {
    try {
      await _firestore.collection('user').doc(id).delete();
      print("Deleted successfully");
    } catch (e) {
      print("Error: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> update(String id, String name, String degree) async { // Fixed parameter name (was email)
    try {
      await _firestore.collection('user').doc(id).update({
        "name": name,
        "degree": degree,
        "updatedAt": FieldValue.serverTimestamp(),
      });
      print("Updated successfully");
    } catch (e) {
      print("Error: ${e.toString()}");
      rethrow;
    }
  }

  Stream<QuerySnapshot> getUsersStream() { // Add this to centralize stream access
    return _firestore.collection('user').snapshots();
  }
}