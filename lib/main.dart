import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'splash_screen.dart';
import 'cart_provider.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const WorthItApp(),
    ),
  );
}

class WorthItApp extends StatelessWidget {
  const WorthItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WorthIt',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
