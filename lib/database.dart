import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() async {
    try {
      await userCollection.add({"name": "John"});
    } catch (e) {
      print(e);
      print("Failed");
    }
  }

 
}
