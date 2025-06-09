import 'package:countries/pages/details/details_page.dart';
import 'package:countries/pages/home/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      routes: {
        '/details': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String;
          return DetailsPage(countryName: args);
        },
      },
    );
  }
}
