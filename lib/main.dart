import 'package:flutter/material.dart';
import 'package:transport_app/pages/all_transport_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AllTransportPage(),
    );
  }
}
