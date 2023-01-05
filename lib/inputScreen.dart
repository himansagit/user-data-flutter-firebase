import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfirebaseapp/showUsers.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  CollectionReference formFields =
      FirebaseFirestore.instance.collection('formFields');
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  FirebaseStorage store = FirebaseStorage.instance;

  List fields = [];
  Map userData = new Map();
  // String? _fileName ;
  String? _filePath;

  void setUserField(String Key, String? Value) {
    userData[Key] = Value;
  }

  Future<void> uploadUserDoc(Map user) async {
    try {
      String load = jsonEncode(user);
      DocumentReference UserRef = await userCollection.add(jsonDecode(load));
      await uploadImage(_filePath!, UserRef.id);
      String downloadURL =
          await store.ref('usersImages/${UserRef.id}').getDownloadURL();
      await userCollection.doc(UserRef.id).update({"imagePath": downloadURL});
      print(UserRef.id);
      // print(UserRef.id);
      print('succes upload');
    } catch (e) {
      print(e.toString());
      print('error');
    }
  }

  Future<void> getFormFields() async {
    QuerySnapshot querySnapshot = await formFields.get();
    setState(() {
      fields = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> uploadImage(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await store.ref('usersImages/$fileName').putFile(file);
    } catch (e) {
      print(e.toString());
      print('error uploading file');
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget getTextField(dynamic doc) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '${doc['label']}',
      ),
      validator: (value) {
        if (value != null && value.trim().isEmpty) {
          //print('validate');
          return '${doc['label']} is required';
        }
      },
      onSaved: (newValue) {
        setUserField('${doc['label']}', newValue);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getFormFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("APP BAR"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => Users())));
              },
              icon: const Icon(Icons.person))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            Column(
              children: fields.map((doc) {
                return getTextField(doc);
              }).toList(),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  final results = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: [
                      'png',
                      'jpg',
                    ],
                  );
                  if (results == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('no file selelcted')));
                    // return null;
                  }
                  final filePath = results!.files.single.path;
                  final fileName = results.files.single.name;

                  _filePath = filePath;
                },
                child: const Text('Upload Image')),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentContext == null) return;
                  if (_formKey.currentState!.validate()) {
                    if (_filePath == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('no file selelcted')));
                      return;
                    }
                    print("success");
                    _formKey.currentState!.save();
                    print(userData);
                    await uploadUserDoc(userData);
                  }
                },
                child: const Text('Submit'))
          ]),
        ),
      ),
    );
  }
}
