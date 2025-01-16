import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tp3/movieItem.dart';
import 'package:http/http.dart' as http;

class Moviepage extends StatefulWidget {
  const Moviepage({super.key});

  @override
  State<Moviepage> createState() => _MoviepageState();
}

class _MoviepageState extends State<Moviepage> {

  List<dynamic> movies = [];
  bool isLoading = true;


   @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final response = await http.get(
        Uri.parse('https://my-json-server.typicode.com/horizon-code-academy/fake-movies-api/movies'),
      );
      if (response.statusCode == 200) {
        setState(() {
          movies = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching movies: $error')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Movieitem(
                  title: movies[index]['Title'] ?? 'Unknown',
                  year: movies[index]['Year'] ?? 'Unknown',
                  runtime: movies[index]['Runtime'] ?? 'Unknown',
                  poster: movies[index]['Poster'],
                );
              },
            ),
    );
  }
}