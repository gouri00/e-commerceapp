import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uber_shop_app/controllers/category_controller.dart';
import 'package:uber_shop_app/views/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // For web
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBAMr0mmkVk6wRK0jOePcUDu_840WFGATU",
          authDomain: "myhub-cf229.firebaseapp.com",
          projectId: "myhub-cf229",
          storageBucket: "myhub-cf229.firebasestorage.app",
          messagingSenderId: "899898765475",
          appId: "1:899898765475:web:8f08874b33d27296a48f16"),
    );
  } else {
    // For web
    await Firebase.initializeApp();
  }

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: MainScreen(),
      initialBinding: BindingsBuilder(() {
        Get.put<CategoryController>(CategoryController());
      }),
    );
  }
}
