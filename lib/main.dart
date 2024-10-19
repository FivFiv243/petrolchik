import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:petrolchik/firebase/firebase_options.dart';
import 'package:petrolchik/screens/authcheck.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yandex_maps_mapkit/init.dart' as init;

void main() async {
  await dotenv.load(fileName: ".env.prod");
  await init.initMapkit(apiKey: '28e79d50-feeb-4c1f-9865-d16417683e6d');
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthCheck(),
    );
  }
}
