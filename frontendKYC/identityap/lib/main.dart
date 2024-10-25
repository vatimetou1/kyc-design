import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:identityap/PersonCard.dart';
import 'dart:convert';
import 'VideoMatchingPage.dart';
import 'details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KYC Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InputPage1(),
    );
  }
}

class InputPage1 extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage1> {
  final TextEditingController _nniController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;

  void fetchPersonInfo() async {
    setState(() {
      isLoading = true;
    });

    var url =
        'http://192.168.1.204:8000/appecash/fetch-person-info/?nni=${_nniController.text}&numero_tel=${_phoneController.text}';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var decodedData = utf8.decode(response.bodyBytes);
      var jsonData = json.decode(decodedData);

      if (jsonData.containsKey('person')) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetailsPage(
              person: Person.fromJson(jsonData['person']),
              nniController: _nniController,
            ),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucune personne trouvée')),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de requête, réessayez plus tard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Suppression du bouton retour
        title: Text(
          'KYC',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Ajout de SingleChildScrollView pour gérer le débordement
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              // Étapes de progression
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StepCircle(
                      isActive: true, stepNumber: '1', label: "info user"),
                  StepLine(),
                  StepCircle(
                      isActive: false, stepNumber: '2', label: "camera kyc"),
                  StepLine(),
                  StepCircle(
                      isActive: false, stepNumber: '3', label: "facture"),
                ],
              ),

              SizedBox(height: 20),

              // Maximisation légère de la carte
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.6, // La carte occupe 60% de la hauteur de l'écran
                ),
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Déplacement des champs en haut
                        Text(
                          'Information User',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Veuillez entrer votre NNI et numéro de téléphone',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Champs de saisie
                        TextField(
                          controller: _nniController,
                          decoration: InputDecoration(
                            labelText: 'NNI',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 30), // Espacement réduit
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Numéro de téléphone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 30), // Espacement réduit

                        // Bouton recherche centré
                        Center(
                          child: ElevatedButton(
                            onPressed: fetchPersonInfo,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Recherche'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Bouton caméra en bas
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VideoMatchingPage(nniK: _nniController)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(
                      0xFFDAA520), // Couleur dorée plus prononcée (goldenrod)
                  padding: EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10), // Réduction de la taille du bouton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Camera kyc'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget pour les cercles d'étape
class StepCircle extends StatelessWidget {
  final bool isActive;
  final String stepNumber;
  final String label;

  const StepCircle(
      {required this.isActive, required this.stepNumber, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isActive
              ? Color(0xFFDAA520) // Couleur dorée plus intense (goldenrod)
              : Colors.grey,
          child: Text(
            stepNumber,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive
                ? Color(0xFFDAA520) // Texte doré pour l'étape active
                : Colors.grey,
          ),
        ),
      ],
    );
  }
}

// Widget pour la ligne entre les cercles d'étape
class StepLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 2,
      color: Colors.grey,
    );
  }
}
