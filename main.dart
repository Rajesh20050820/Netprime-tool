import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MoviePostGenerator());
}

class MoviePostGenerator extends StatefulWidget {
  @override
  _MoviePostGeneratorState createState() => _MoviePostGeneratorState();
}

class _MoviePostGeneratorState extends State<MoviePostGenerator> {
  TextEditingController urlController = TextEditingController();
  String generatedPost = "Enter movie URL and press 'Generate'.";

  Future<void> generatePost() async {
    String url = urlController.text;
    if (url.isEmpty) {
      setState(() {
        generatedPost = "Please enter a movie URL!";
      });
      return;
    }

    var response = await http.get(Uri.parse("https://your-api-link.com/scrape?url=$url"));

    if (response.statusCode == 200) {
      setState(() {
        generatedPost = jsonDecode(response.body)["html"];
      });
    } else {
      setState(() {
        generatedPost = "Error fetching data!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Movie Post Generator")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: "Enter Movie URL"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: generatePost,
                child: Text("Generate Post"),
              ),
              SizedBox(height: 20),
              SelectableText(generatedPost),
            ],
          ),
        ),
      ),
    );
  }
}
