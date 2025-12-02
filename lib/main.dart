import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

import 'package:toutaz_cafe/ui/navigation/mainNavigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await signInAnonymously();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

Future<void> signInAnonymously() async {
  final auth = FirebaseAuth.instance;

  if (auth.currentUser == null) {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(
          "Erreur lors du lancement de l'application.\nVeuillez la redémarrer");
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
      ),
      title: "Tout'az café",
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
