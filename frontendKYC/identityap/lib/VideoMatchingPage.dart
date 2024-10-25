import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'camera.dart';

class VideoMatchingPage extends StatefulWidget {
  final TextEditingController nniK;
  VideoMatchingPage({Key? key, required this.nniK}) : super(key: key);

  @override
  _VideoMatchingPageState createState() => _VideoMatchingPageState();
}

class _VideoMatchingPageState extends State<VideoMatchingPage> {
  bool isMatching = false;
  String matchResult = 'Matching ..';
  final TextEditingController nniController = TextEditingController();

  void startMatching(String imagePath) async {
    if (!mounted) return;

    setState(() {
      isMatching = true;
      matchResult = 'Matching in progress...';
    });

    try {
      String nni = nniController.text;
      var url = 'http://192.168.1.204:8000/appecash/match-face/?nni=$nni';

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (!mounted) return;

      if (response.statusCode == 200) {
        var data = json.decode(responseBody);
        setState(() {
          matchResult = data['message'];
          isMatching = false;
        });
      } else {
        setState(() {
          matchResult = 'Failed to match face: $responseBody';
          isMatching = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        matchResult = 'Failed to match face: $e';
        isMatching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Video Matching',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Étapes de progression
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StepCircle(
                    isActive: false, stepNumber: '1', label: "info user"),
                StepLine(),
                StepCircle(
                    isActive: true,
                    stepNumber: '2',
                    label: "camera kyc"), // Deuxième cercle doré
                StepLine(),
                StepCircle(isActive: false, stepNumber: '3', label: "facture"),
              ],
            ),
          ),

          // Espace centralisé avec bouton et texte
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Bouton Start Matching
                  ElevatedButton(
                    onPressed: isMatching
                        ? null
                        : () async {
                            final capturedImage = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CameraPage()),
                            );

                            if (capturedImage != null) {
                              startMatching(capturedImage);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          Color(0xFFDAA520), // Couleur dorée (gold)
                      padding: EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15), // Bouton plus grand
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Start Matching'),
                  ),

                  // Espace et texte du résultat
                  SizedBox(height: 20),
                  Text(
                    matchResult,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isMatching ? Colors.grey : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Espace vide pour équilibrer le layout
          Expanded(
            child: Center(
              child:
                  isMatching ? CircularProgressIndicator() : SizedBox.shrink(),
            ),
          ),
        ],
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
              ? Color(
                  0xFFDAA520) // Couleur dorée (goldenrod) pour l'étape active
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
