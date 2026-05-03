import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/injection.dart';
import '../../domain/splash_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _mulaiAplikasi();
  }

  void _mulaiAplikasi() async {
    // Memanggil fungsi delay 5 detik yang sudah dibuat di Service (Langkah 3)
    await sl<SplashService>().jalankanDelayAplikasi();
    if (mounted) context.go('/home'); // Pindah ke home setelah 5 detik
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("UTD Store - Fitri", 
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Text("NIM: 20123020", 
              style: TextStyle(fontSize: 18, color: Colors.white70)),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Colors.white), // Animasi loading
          ],
        ),
      ),
    );
  }
}