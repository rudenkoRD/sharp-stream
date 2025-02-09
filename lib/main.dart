import 'package:flutter/material.dart';
import 'package:sharp_stream/home_page.dart';
import 'package:sharp_stream/theme/theme.dart';
import 'package:sharp_stream/theme/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = createTextTheme(context, "Quantico", "Quantico");
    final theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Sharp stream',
      debugShowCheckedModeBanner: false,
      theme: theme.dark(),
      home: const HomePage(),
    );
  }
}
