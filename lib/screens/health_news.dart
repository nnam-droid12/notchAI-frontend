import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HealthNews extends StatefulWidget {
  const HealthNews({Key? key}) : super(key: key);

  @override
  _HealthNewsState createState() => _HealthNewsState();
}

class _HealthNewsState extends State<HealthNews> {
  List<dynamic> newsData = [];
  static final healthApikey = dotenv.env["HealthNews_API_KEY"];

  @override
  void initState() {
    super.initState();
    fetchHealthNews();
  }

  Future<void> fetchHealthNews() async {
    var apiUrl =
        'https://newsapi.org/v2/top-headlines?category=health&language=en&apiKey=$healthApikey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          newsData = jsonData['articles'];
        });
      } else {
        throw Exception('Failed to load health news');
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health News'),
        backgroundColor: const Color(0xFF097969),
      ),
      body: ListView.builder(
        itemCount: newsData.length,
        itemBuilder: (context, index) {
          final article = newsData[index];
          final String imageUrl = article['urlToImage'] ?? '';

          return ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                border: Border.all(color: const Color(0xFF097969), width: 2.0),
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(10.0), // Clip rounded corners
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey, // Placeholder color
                      ),
              ),
            ),
            title: Text(article['title'] ?? 'No title available'),
            subtitle:
                Text(article['description'] ?? 'No description available'),
            onTap: () {
              // Add your onTap logic here
            },
          );
        },
      ),
    );
  }
}
