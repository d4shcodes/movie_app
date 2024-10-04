import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movie_app/models/model_movie.dart';

class apiService {
  static Future<List<movie_modules>> getMovies() async {
    var movieAPI_url = 'https://api.tvmaze.com/shows/1/episodes';

    try {
      final uri = Uri.parse(movieAPI_url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> movieData = jsonDecode(response.body);
        return movieData.map((data) => movie_modules.fromJson(data as Map<String, dynamic>)).toList();
      } else {
        debugPrint('Failed to load movies');
        return [];
      }
    } catch (error) {
      debugPrint('Error fetching movies: $error');
      return [];
    }
  }
}
