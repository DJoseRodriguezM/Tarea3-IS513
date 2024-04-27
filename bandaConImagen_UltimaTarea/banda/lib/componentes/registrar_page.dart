import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:banda/routes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegistrarPage extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance.ref();

  RegistrarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nombreBandaController = TextEditingController();
    final nombreAlbumController = TextEditingController();
    final anioLanzamientoController = TextEditingController();
    final votosController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    String? imgUrl;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 47, 47),
      appBar: AppBar(
        title: const Text('Registrar'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Registre su Banda de Rock',
                          style: TextStyle(
                            color: Color.fromARGB(255, 221, 221, 221),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 13.0),
                    TextFormField(
                      style: const TextStyle(
                        color: Color.fromARGB(255, 221, 221, 221),
                      ),
                      controller: nombreBandaController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo obligatorio';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre de la Banda',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 221, 221, 221),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 221, 221, 221),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      style: const TextStyle(
                        color: Color.fromARGB(255, 221, 221, 221),
                      ),
                      controller: nombreAlbumController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo obligatorio';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre del Album',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 221, 221, 221),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 221, 221, 221),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      style: const TextStyle(
                        color: Color.fromARGB(255, 221, 221, 221),
                      ),
                      controller: anioLanzamientoController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo obligatorio';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Año de lanzamiento',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 221, 221, 221),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 221, 221, 221),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      style: const TextStyle(
                        color: Color.fromARGB(255, 221, 221, 221),
                      ),
                      controller: votosController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo obligatorio';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Cantidad de votos',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 221, 221, 221),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 221, 221, 221),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);

                        if (image != null) {
                          Reference imagenRef = storage.child(
                              'images/${DateTime.now().millisecondsSinceEpoch}.jpg');

                          try {
                            await imagenRef.putFile(File(image.path));
                            imgUrl = await imagenRef.getDownloadURL();
                            print('Imagen subida exitosamente: $imgUrl');
                          } catch (e) {
                            print('Error al subir la imagen: $e');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 50,
                        ),
                        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
                      ),
                      child: const Text(
                        'Foto del Album (Opcional)',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 210, 210, 210),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {

                          final data = {
                            'nombreBanda': nombreBandaController.text,
                            'nombreAlbum': nombreAlbumController.text,
                            'anioLanza':
                                int.parse(anioLanzamientoController.text),
                            'votos': int.parse(votosController.text),
                            'imgUrl': imgUrl ?? '', //si imgUrl es null, se asigna un string vacío
                          };

                          try {
                            final instance = FirebaseFirestore.instance;
                            final resp =
                                await instance.collection('bandaimg').add(data);
                            print('ID Banda: ${resp.id}');
                          } catch (e) {
                            print('Fallo al agregar: $e');
                          }
                          Navigator.pushReplacementNamed(
                              context, MyRoutes.home.name);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 50,
                        ),
                        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
                      ),
                      child: const Text(
                        'Agregar Banda',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 210, 210, 210),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
