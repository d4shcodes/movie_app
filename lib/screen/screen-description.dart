import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/theme/colors.dart';

class Description extends StatefulWidget {
  final int? id;

  Description({required this.id});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  int? movie_id;
  Map<String, dynamic>? movieData; // Store the movie data

  // Method to fetch movie details from the API using the movie ID
  Future<void> fetchMovieDetails() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/episodes/${movie_id}'));

    if (response.statusCode == 200) {
      setState(() {
        movieData = json.decode(response.body); // Parse the response
        print(movieData);
      });
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    movie_id = widget.id;
    fetchMovieDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 20,
          backgroundColor: AppColors.primaryText,
        ),
        body: movieData == null
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryText,
                ),
              )
            : Column(
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: movieData?['image']?['original'] ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width * 0.45,
                      ),
                      Container(
                        width: double.infinity, // Ensuring the gradient covers the full width
                        height: MediaQuery.of(context).size.width * 0.45, // Same height as the image
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                            stops: const [0.1, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(60.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieData!['name'], // Display movie title
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06, color: AppColors.secondaryText, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 50.sp),
                        Row(
                          children: [
                            sub_info('SEASON : ${movieData!['season']}'),
                            SizedBox(
                              width: 20.sp,
                            ),
                            sub_info('RATING : ${movieData?['rating']?['average'] ?? ''}'),
                          ],
                        ),
                        SizedBox(height: 50.sp),
                        Text(
                          _removeHtmlTags(movieData!['summary']), // Display movie title
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: AppColors.secondaryText, fontWeight: FontWeight.w200),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 45.sp),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              print('pressed');
                            },
                            child: Text("WATCH NOW", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.w700)),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColors.primaryText), foregroundColor: MaterialStateProperty.all(AppColors.secondaryText)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ));
  }

  Container sub_info(String info) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0.sp),
        color: AppColors.primaryText,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.sp),
        child: Text(
          info,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: AppColors.secondaryText, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

String _removeHtmlTags(String htmlString) {
  final RegExp exp = RegExp(r'<[^>]*>');
  return htmlString.replaceAll(exp, '').trim(); // Replace HTML tags and trim whitespace
}
