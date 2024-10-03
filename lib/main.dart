import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/screen/screen-homepage.dart';
import 'package:movie_app/theme/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: AppColors.scaffoldBackground,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primaryText, // Set the AppBar background color
            titleTextStyle: TextStyle(
                color: Colors.white, // Set the AppBar title text color
                fontSize: 20,
                fontFamily: 'Poppins'),
            iconTheme: IconThemeData(
              color: Colors.white, // Set the AppBar icon color
            ),
          ),
        ),
      ),
      designSize: const Size(1080, 2400),
    );
  }

  const MyApp({super.key});
}
