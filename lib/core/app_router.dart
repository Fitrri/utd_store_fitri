import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../presentation/pages/splash_page.dart';

final router = GoRouter(
  initialLocation: '/splash', // Aplikasi akan mulai dari sini
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text("Halaman Utama - Fitri")),
      ),
    ),
  ],
);