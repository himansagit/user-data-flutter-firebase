import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String _name;
  String _email;
  String _url;
  String _number

  final GlobalKey<FormState> _formKey =GlobalKey<FormState>(); 

  Widget _buildName (){
    return null;
  }

    Widget _buildEmail (){
    return null;
  }

    Widget _buildUrl (){
    return null;
  }

    Widget _buildNumber (){
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input'),
      ),
      body: Container(
        margin: EdgeInsets.all(25),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              _buildEmail(),
              _buildUrl(),
              _buildNumber()
            ],
          ),
        ),
      ),
    );
  }
}
