import 'package:flutter/material.dart';
import 'package:moviestore/presentation/pages/homeScreen.dart';
import 'package:moviestore/presentation/pages/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // Define your home screen here
      // routes: {
      //   '/movie-list': (context) => MovieListPage(),
      // },
    );
  }
}
