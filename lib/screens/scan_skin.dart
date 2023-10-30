import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:notchai_frontend/screens/community_home_screen.dart';
import 'package:notchai_frontend/services/assets_manager.dart';
import 'package:notchai_frontend/services/services.dart';
import 'package:scanning_effect/scanning_effect.dart';

class ScanTech extends StatefulWidget {
  const ScanTech({Key? key}) : super(key: key);

  @override
  _ScanTechState createState() => _ScanTechState();
}

class _ScanTechState extends State<ScanTech> {
  File? selectedImage;
  Prediction? highestAccuracyPrediction;
  static final openaiApikey = dotenv.env["OPENAI_API_KEY"];
  static final autodermApikey = dotenv.env["Autoderm_API_KEY"];
  bool isAnalyzing = false;
  bool showResultText = false; // Control text animation

  Future<void> _selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<List<String>> _getCausesAndRecommendations(String predictionName) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openaiApikey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a helpful assistant that provides causes and recommendations for skin conditions.'
            },
            {
              'role': 'user',
              'content':
                  'What are the causes and recommendations for $predictionName?'
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final completions = data['choices'][0]['message']['content'].split('\n');
        return completions;
      } else {
        throw Exception('Failed to load data from OpenAI API');
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> _analyzeImage() async {
    if (selectedImage != null) {
      try {
        setState(() {
          isAnalyzing = true;
        });

        var request =
            http.MultipartRequest('POST', Uri.parse('https://autoderm.firstderm.com/v1/query'));

        request.headers['Api-Key'] = '$autodermApikey';

        request.fields['model'] = 'autoderm_v2_0';
        request.fields['language'] = 'en';

        request.files.add(await http.MultipartFile.fromPath('file', selectedImage!.path));

        var response = await request.send();
        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var jsonData = json.decode(responseBody);

          var predictions = jsonData['predictions'];

          Prediction highestConfidencePrediction = predictions
              .map((prediction) => Prediction(
                    name: prediction['name'],
                    confidence: prediction['confidence'],
                  ))
              .reduce((a, b) => a.confidence > b.confidence ? a : b);

          highestAccuracyPrediction = highestConfidencePrediction;
        } else {
          // Handle error
        }
      } catch (e) {
        // Handle error
      } finally {
        setState(() {
          isAnalyzing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Image.asset(
          AssetsManager.notchaiLogo,
          fit: BoxFit.contain,
        ),
        backgroundColor: const Color(0xFF00C6AD),
        title: const Text("Scan Skin"),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFB2FFFF), Color(0xFFB2FFFF)],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: isAnalyzing
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect( 
                                borderRadius: BorderRadius.circular(16), 
                                child: Image.file(selectedImage!, fit: BoxFit.cover),
                            ),
                              const ScanningEffect( 
                                scanningColor: Colors.green,
                                borderLineColor: Color(0xFF00C6AD),
                                delay: Duration(milliseconds: 500),
                                duration: Duration(milliseconds: 700),
                                child: SizedBox(),
                              )
                            ],
                          )
                        : selectedImage != null
                            ? ClipRRect(
                                 borderRadius: BorderRadius.circular(16), 
                                 child: Image.file(selectedImage!, fit: BoxFit.cover),
                           )
                            : const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 64,
                              ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _selectImage,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF00C6AD),
                          elevation: 5,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Row(
                          children: <Widget>[
                            Icon(Icons.image),
                            SizedBox(width: 10),
                            Text('Select Image'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => _analyzeImage(),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF00C6AD),
                          elevation: 5,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: isAnalyzing
                            ? const Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text('Scanning Image'), // Show text
                                  ScanningEffect( 
                                    scanningColor: Colors.green,
                                    borderLineColor: Color(0xFF00C6AD),
                                    delay: Duration(milliseconds: 500),
                                    duration: Duration(milliseconds: 700),
                                    child: SizedBox(),
                                  )
                                ],
                              )
                            : const Row(
                                children: <Widget>[
                                  Icon(Icons.analytics),
                                  SizedBox(width: 10),
                                  Text('Scan Image'),
                                ],
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (highestAccuracyPrediction != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Diagnostic Result',
                            style: TextStyle(
                              color: Color(0xFF00C6AD),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFF00C6AD)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (!showResultText)
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        highestAccuracyPrediction?.showCausesAndRecommendations = true;
                                        showResultText = true; // Start the text animation
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xFF00C6AD),
                                      elevation: 5,
                                      shadowColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(20),
                                    ),
                                    child: const Text('Causes and Recommendations'),
                                  ),
                               if (showResultText) 
                              Text(
                                  highestAccuracyPrediction!.name,
                                  style: const TextStyle(
                                    color: Color(0xFF00C6AD),
                                    fontSize: 18,
                                  ),
                                )

                              ],
                            ),
                          ),
                          if (highestAccuracyPrediction!.showCausesAndRecommendations)
                            FutureBuilder<List<String>>(
                              future: _getCausesAndRecommendations(highestAccuracyPrediction!.name),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  var causesAndRecommendations = snapshot.data;
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Causes and Recommendations:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF00C6AD),
                                        ),
                                      ),
                                      if (causesAndRecommendations != null)
                                        for (var item in causesAndRecommendations)
                                          Text(
                                            '- $item',
                                            style: const TextStyle(
                                              color: Color(0xFF00C6AD),
                                              fontSize: 18,
                                            ),
                                          ),
                                    ],
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CommunityHomeScreen(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF00C6AD),
                      elevation: 8,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(20),
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(
                        color: Color(0xFF00C6AD),
                        width: 2,
                      ),
                    ),
                    icon: const Icon(Icons.group, size: 28),
                    label: const Text('Join Community'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Prediction {
  final String name;
  final double confidence;
  bool showCausesAndRecommendations;

  Prediction({
    required this.name,
    required this.confidence,
    this.showCausesAndRecommendations = false,
  });
}

class ImagePlaceholder extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ImagePlaceholder({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.camera_alt,
      color: Colors.white,
      size: 64,
    );
  }
}