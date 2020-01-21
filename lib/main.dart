import 'package:flutter/material.dart';
import 'package:meetap_firebase/page/beranda.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFFD51515),
        scaffoldBackgroundColor: const Color(0xFF35ABAB),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color(0xFF1E6ED3)
        )
      ),
      debugShowCheckedModeBanner: false,
      title: 'Firebase',
      home: Beranda(),
    );
  }
}