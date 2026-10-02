import 'package:flutter/material.dart';

import 'pages/registration_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Register Form',
      theme: ThemeData(
        useMaterial3: false, // классический вид AppBar, как на макете
        primarySwatch: Colors.blue,
      ),
      home: const RegistrationPage(),
    );
  }
}
