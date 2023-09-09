import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HealthNews extends StatefulWidget {
  const HealthNews({Key? key}) : super(key: key);

  @override
  _HealthNewsState createState() => _HealthNewsState();
}

class _HealthNewsState extends State<HealthNews> {
  List<dynamic> newsData = []; // Store the fetched news data here

  @override
  void initState() {
    super.initState();
    fetchHealthNews(); // Fetch news data when the widget initializes
  }

  Future<void> fetchHealthNews() async {
    const apiKey =
        '605b5261cd5b4734853884a71e80b2a2'; // Replace with your News API key
    const apiUrl =
        'https://newsapi.org/v2/top-headlines?category=health&language=en&apiKey=$apiKey';

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
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health News'),
      ),
      body: ListView.builder(
        itemCount: newsData.length,
        itemBuilder: (context, index) {
          final article = newsData[index];
          final String imageUrl =
              article['urlToImage'] ?? ''; // Get the image URL

          return ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                border: Border.all(color: Colors.black, width: 2.0),
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
