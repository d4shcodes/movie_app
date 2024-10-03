import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/screen/screen-description.dart';
import 'package:movie_app/theme/colors.dart';
import '../models/model_movie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var movieAPI_url = 'https://api.tvmaze.com/shows/1/episodes';
  List<movie_modules> movieList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMovie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(40.sp),
          child: movieList.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.all(20.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'YEFLIX',
                            style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.08, color: AppColors.primaryText), // Responsive font size
                          ),
                          const Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: AppColors.primaryText,
                          )
                        ],
                      ),
                      SizedBox(height: 20.sp),
                      Expanded(
                        child: GridView.builder(
                          itemCount: movieList.length,
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                            childAspectRatio: 2 / 3,
                            crossAxisSpacing: 30.sp,
                            mainAxisSpacing: 40.sp,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                // print("Episode : ${movieList[index].id}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Description(id: movieList[index].id)),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.sp),
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: movieList[index].image?.original ?? '',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.9),
                                          ],
                                          stops: const [0.5, 1.0],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 12.sp,
                                      right: 12.sp,
                                      bottom: 50.sp,
                                      child: Text(
                                        '${movieList[index].name}',
                                        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: AppColors.secondaryText),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.redAccent,
                  ),
                ),
        ),
      ),
    );
  }

  //Create a function
  void getMovie() {
    final uri = Uri.parse(movieAPI_url);
    http.get(uri).then((response) {
      //If request successful
      if (response.statusCode == 200) {
        // print(response.body);
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        final List movieData = decodedData;

        for (var i = 0; i < movieData.length; i++) {
          //FromJSON converts JSON into dart objects
          final movies = movie_modules.fromJson(movieData[i] as Map<String, dynamic>);
          movieList.add(movies);
        }
        //Updates the state
        setState(() {});
      }
    }).catchError((err) {
      debugPrint("Error : $err");
    });
  }
}
