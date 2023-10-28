import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FullNewsPage extends StatefulWidget {
  final Map<String, dynamic> article;

  const FullNewsPage({Key? key, required this.article}) : super(key: key);

  @override
  _FullNewsPageState createState() => _FullNewsPageState(article: article);
}

class _FullNewsPageState extends State<FullNewsPage> {
  final Map<String, dynamic> article;
  String? summary;

  _FullNewsPageState({required this.article});

  Future<String> summarizeArticle() async {
    final openAIKey = dotenv.env['OPENAI_API_KEY'];
    final articleText = article['content'] ?? '';
    const apiUrl = 'https://api.openai.com/v1/engines/davinci-codex/completions';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $openAIKey',
    };

    final data = {
      'prompt': 'Summarize the following news article:\n$articleText',
      'max_tokens': 100, // Adjust the number of tokens as needed
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final summaryText = jsonData['choices'][0]['text'];
      setState(() {
        summary = summaryText;
      });
      return summaryText;
    } else {
      throw Exception('Failed to summarize article');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['title'] ?? 'No title available'),
        backgroundColor: const Color(0xFF00C6AD), 
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(article['urlToImage'] ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                article['title'] ?? 'No title available',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                child: Text(
                  article['description'] ?? 'No description available',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                child: Text(
                  article['content'] ?? 'No content available',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (summary != null)
                const SizedBox(height: 16),
                const Text(
                  '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
               
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    summarizeArticle();
  },
  backgroundColor: const Color(0xFF00C6AD), // Set the color to #FF00C6AD
  child: const Icon(Icons.summarize),
),
    );
  }
}