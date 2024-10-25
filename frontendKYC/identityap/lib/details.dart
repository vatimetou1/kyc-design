import 'package:flutter/material.dart';
import 'PersonCard.dart';
import 'VideoMatchingPage.dart';

class PersonDetailsPage extends StatelessWidget {
  final Person person;
  final TextEditingController nniController;

  PersonDetailsPage({required this.person, required this.nniController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arrière-plan blanc pour la page
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Enlever l'ombre de l'AppBar
        title: Text(
          'Détails de la Personne',
          style: TextStyle(color: Colors.black), // Texte noir pour l'AppBar
        ),
        centerTitle: true,
        iconTheme:
            IconThemeData(color: Colors.black), // Couleur de l'icône de retour
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  color: Colors.grey[200], // Changer la couleur de la carte ici
                  elevation: 10, // Élève la carte pour créer une ombre
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Bordures arrondies
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        20.0), // Espacement interne de la carte
                    child: PersonCard(
                        person:
                            person), // Le contenu de la carte reste inchangé
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Bouton doré "Camera KYC"
            ElevatedButton(
              onPressed: () {
                // Navigation vers VideoMatchingPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          VideoMatchingPage(nniK: nniController)),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // Couleur du texte en blanc
                backgroundColor: Color(0xFFDAA520), // Couleur dorée (gold)
                padding: EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15), // Taille du bouton
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordures arrondies
                ),
              ),
              child: Text('Camera KYC'),
            ),
          ],
        ),
      ),
    );
  }
}
