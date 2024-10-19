import 'package:flutter/material.dart';
import 'package:petrolchik/firebase/firebase_auth.dart';
import 'package:petrolchik/screens/app_screen.dart';
import 'package:petrolchik/screens/authscreen.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FireAuth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.emailVerified == true) {
          return AppScreen(); // here app screen
        } else {
          return AuthScreen(); // here reg screen
        }
      },
    ));
  }
}
