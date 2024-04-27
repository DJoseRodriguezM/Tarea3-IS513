import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VotarPage extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  VotarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bandas = firestore.collection('bandaimg').snapshots();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 47, 47),
      appBar: AppBar(
        title: const Text('Votaciones'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bandas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final bandasRock = snapshot.data!.docs;

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Vote Por su Banda de Rock Favorita',
                      style: TextStyle(
                        color: Color.fromARGB(255, 221, 221, 221),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: bandasRock.length,
                      itemBuilder: (context, index) {
                        final banda = bandasRock[index];
                        final votos = banda['votos'].toString();

                        return Card(
                          color: const Color.fromRGBO(184, 184, 184, 1),
                          margin: const EdgeInsets.all(8.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: banda['imgUrl'] != '' //si hay una ruta de imagen en la base de datos
                                    ? Image.network(
                                        banda['imgUrl'],
                                        fit: BoxFit.cover,
                                        height: 60.0,
                                        width: 60.0,
                                      )
                                    : Image.asset( //si NO HAY una ruta de imagen en la base de datos, carga una local
                                        'assets/album.png',
                                        fit: BoxFit.cover,
                                        height: 60.0,
                                        width: 60.0,
                                      ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              title: Text(
                                'Nombre: ${banda['nombreBanda']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Album: ${banda['nombreAlbum']}'),
                                  Text(
                                      'Año de Lanzamiento: ${banda['anioLanza']}'),
                                ],
                              ),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset('assets/votos.png',
                                      width: 30, height: 30),
                                  const SizedBox(height: 4),
                                  Text(votos.toString()),
                                ],
                              ),
                              onTap: () async {
                                DocumentReference docRef = FirebaseFirestore
                                    .instance
                                    .collection('bandaimg')
                                    .doc(banda.id);
                                FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot snapshot =
                                      await transaction.get(docRef);

                                  if (!snapshot.exists) {
                                    throw Exception("El documento no existe!");
                                  } else {
                                    int nVotos = snapshot.get('votos') + 1;
                                    transaction
                                        .update(docRef, {'votos': nVotos});
                                  }
                                });
                              }),
                        );
                      }),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
