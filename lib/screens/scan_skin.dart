import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:notchai_frontend/screens/api_secrets.dart';
import 'dart:io';

class ScanTech extends StatefulWidget {
  const ScanTech({Key? key}) : super(key: key);

  @override
  _ScanTechState createState() => _ScanTechState();
}

class _ScanTechState extends State<ScanTech> {
  File? selectedImage;
  List<Prediction> predictionList = [];

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
          'Authorization': 'Bearer $stableDiffusionModelAPIKey',
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
      // ignore: avoid_print
      print('Error: $e');
      return [];
    }
  }

  Future<void> _analyzeImage() async {
    if (selectedImage != null) {
      try {
        var request = http.MultipartRequest(
            'POST', Uri.parse('https://autoderm.firstderm.com/v1/query'));

        request.headers['Api-Key'] =
            'b9cJgVLaZ_IpTvCgt4k5qzIpNWo8aU8IXY-ga5I8Wq0';

        request.fields['model'] = 'autoderm_v2_0';

        request.fields['language'] = 'en';

        request.files.add(
            await http.MultipartFile.fromPath('file', selectedImage!.path));

        var response = await request.send();
        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var jsonData = json.decode(responseBody);

          var predictions = jsonData['predictions'];

          predictionList.clear();

          for (var prediction in predictions.take(2)) {
            var name = prediction['name'];

            var pred = Prediction(
              name: name,
            );

            predictionList.add(pred);
          }

          setState(() {});
        } else {
          // ignore: avoid_print
          print('Error: ${response.reasonPhrase}');
        }
      } catch (e) {
        // ignore: avoid_print
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                padding: const EdgeInsets.all(20),
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
              if (predictionList.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF097969),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Here are your top 2 answers ranked in order',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: predictionList.length,
                        itemBuilder: (context, index) {
                          var prediction = predictionList[index];
                          return Container(
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        prediction.name,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (!prediction
                                        .showCausesAndRecommendations)
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            prediction
                                                    .showCausesAndRecommendations =
                                                true;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                            'See Causes and Recommendations'),
                                      ),
                                  ],
                                ),
                                if (prediction.showCausesAndRecommendations)
                                  FutureBuilder<List<String>>(
                                    future: _getCausesAndRecommendations(
                                        prediction.name),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        var causesAndRecommendations =
                                            snapshot.data;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Causes and Recommendations:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            if (causesAndRecommendations !=
                                                null)
                                              for (var item
                                                  in causesAndRecommendations)
                                                Text('- $item',
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Prediction {
  final String name;
  bool showCausesAndRecommendations;

  Prediction({
    required this.name,
    this.showCausesAndRecommendations = false,
  });
}
