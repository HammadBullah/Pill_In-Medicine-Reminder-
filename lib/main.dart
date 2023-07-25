import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pill_in/pages/home_page.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, DeviceType){
      return MaterialApp(
      title: 'Pill it',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color.fromARGB(255, 255, 255, 255),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
          appBarTheme: const AppBarTheme(
          backgroundColor:  Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
        ),
        textTheme: TextTheme(
          headlineMedium: GoogleFonts.aBeeZee(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: const Color.fromARGB(255, 29, 29, 29) 
          ),
          titleSmall: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: const Color.fromARGB(255, 29, 29, 29)),
        ),
      ),
      home: const HomePage(),
      );
  });
  }
}
