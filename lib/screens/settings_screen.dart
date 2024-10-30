import 'package:flutter/material.dart';
import 'package:petrolchik/firebase/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Center(
        child: TextButton(
            onPressed: () {
              FireAuth().SignOutAcc();
            },
            child: Text("Sign out")),
      )),
    );
  }
}
