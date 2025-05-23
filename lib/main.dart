import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'homepage.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox('authorBox');
  await Hive.openBox('bookBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
