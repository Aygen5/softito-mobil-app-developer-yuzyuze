import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:_3_kasim_veri/screens/firestore_yonetim_ekrani.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase bağlantısının başlatılması
  await Firebase.initializeApp();
  runApp(const SoftitoFirestoreUygulamasi());
}

class SoftitoFirestoreUygulamasi extends StatelessWidget {
  const SoftitoFirestoreUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cloud FireStore Yönetimi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const FirestoreYonetimEkrani(),
    );
  }
}
