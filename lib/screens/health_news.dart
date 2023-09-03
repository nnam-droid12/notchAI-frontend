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
    const apiKey = '605b5261cd5b4734853884a71e80b2a2'; // Replace with your News API key
    const apiUrl =
        'https://newsapi.org/v2/top-headlines?category=health&apiKey=$apiKey';

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
          return ListTile(
            title: Text(article['title']),
            subtitle: Text(article['description']),
            onTap: () {
             
            },
          );
        },
      ),
    );
  }
}
