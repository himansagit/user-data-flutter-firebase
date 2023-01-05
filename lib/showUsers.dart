import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  List users = [];

  FirebaseStorage store = FirebaseStorage.instance;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  Future<void> getUserList() async {
    QuerySnapshot querySnapshot = await userCollection.get();
    setState(() {
      users = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<String?> downloadURL(String filePath) async {
    String downloadURL =
        await store.ref('usersImages/$filePath').getDownloadURL();
    return downloadURL;
  }

  Widget getUserCard(dynamic e) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Image.network('${e['imagePath']}'),
              title: Text('${e['Email']}'),
              subtitle: Text('${e['Info']}'),
            ),
            Padding(padding: EdgeInsets.all(10), child: Text('${e['Name']}')),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(" CURRENT USERS"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: users.map((e) {
            return getUserCard(e);
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getUserList();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
