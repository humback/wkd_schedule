import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wkd_schedule/views/home_page_2.dart';


class MyHttpOverrides extends HttpOverrides {
@override
HttpClient createHttpClient(SecurityContext? context) {
return super.createHttpClient(context)
  ..badCertificateCallback =
      (X509Certificate cert, String host, int port) => true; }}


Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
  SharedPreferences pre = await SharedPreferences.getInstance();
  pre.setString("name", "FlutterCampus"); //save string
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
    );
  }
}

