import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrarPage extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RegistrarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Banda'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      ),
      body: const SafeArea(
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}