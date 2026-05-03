import 'package:flutter/material.dart';
import 'core/injection.dart' as di;
import 'core/app_router.dart';

void main() async {
  // 1. Pastikan binding flutter siap
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Jalankan Dependency Injection kita
  await di.inisialisasi(); 
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UTD Store Fitri',
      debugShowCheckedModeBanner: false,
      // 3. Panggil router kita agar langsung ke Splash Screen
      routerConfig: router, 
    );
  }
}