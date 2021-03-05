import 'package:flutter/material.dart';
import 'package:flutter_todo/views/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Api',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      supportedLocales: [
        const Locale('en', 'US'),
      ],
    );
  }
}


