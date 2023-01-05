import 'package:flutter/material.dart';
import 'inputScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    title: "APP TITLE",
    home: InputScreen(),
  ));
}
