import 'package:flutter/material.dart';
import 'package:flutterfirebaseapp/showUsers.dart';
import 'inputScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title:  "APP TITLE",
    home: const  InputScreen(),
  ));
}
