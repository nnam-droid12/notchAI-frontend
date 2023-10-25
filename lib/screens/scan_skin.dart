import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

import 'package:notchai_frontend/screens/community_home_screen.dart';

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

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<List<String>> _getCausesAndRecommendations(
      String predictionName) async {
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
        final completions =
            data['choices'][0]['message']['content'].split('\n');
        return completions;
      } else {
        throw Exception('Failed to load data from OpenAI API');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<void> _analyzeImage() async {
    if (selectedImage != null) {
      try {
        var request = http.MultipartRequest(
            'POST', Uri.parse('https://autoderm.firstderm.com/v1/query'));

        request.headers['Api-Key'] = '$autodermApikey';

        request.fields['model'] = 'autoderm_v2_0';
        request.fields['language'] = 'en';

        request.files.add(
            await http.MultipartFile.fromPath('file', selectedImage!.path));

        var response = await request.send();
        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var jsonData = json.decode(responseBody);

          var predictions = jsonData['predictions'];

          // double highestConfidence = 0.0;
          Prediction highestConfidencePrediction = predictions
              .map((prediction) => Prediction(
                    name: prediction['name'],
                    confidence: prediction['confidence'],
                  ))
              .reduce((a, b) => a.confidence > b.confidence ? a : b);

          highestAccuracyPrediction = highestConfidencePrediction;

          setState(() {});
        } else {
          print('Error: ${response.reasonPhrase}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Skin'),
        backgroundColor: const Color(0xFF097969),
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: const Color(0xFF097969),
            child: const Text(
              'Send me a good picture that describes your skin concern',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF097969),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                selectedImage != null
                    ? Image.file(selectedImage!, height: 200, width: 200)
                    : const Text('No Image Selected'),
                ElevatedButton(
                  onPressed: _selectImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF097969),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Select Image'),
                ),
                ElevatedButton(
                  onPressed: _analyzeImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF097969),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Analyze Image'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (highestAccuracyPrediction != null)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF097969),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    'Highest Confidence Diagnostic Result',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF097969),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          highestAccuracyPrediction!.name,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!highestAccuracyPrediction!
                            .showCausesAndRecommendations)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                highestAccuracyPrediction!
                                    .showCausesAndRecommendations = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('See Causes and Recommendations'),
                          ),
                      ],
                    ),
                  ),
                  if (highestAccuracyPrediction!.showCausesAndRecommendations)
                    FutureBuilder<List<String>>(
                      future: _getCausesAndRecommendations(
                          highestAccuracyPrediction!.name),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          var causesAndRecommendations = snapshot.data;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Causes and Recommendations:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (causesAndRecommendations != null)
                                for (var item in causesAndRecommendations)
                                  Text('- $item',
                                      style:
                                          const TextStyle(color: Colors.white)),
                            ],
                          );
                        }
                      },
                    ),
                ],
              ),
            ),
          Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF097969),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CommunityHomeScreen(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF097969),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Join Community'),
                ),
              ),
            ],
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
