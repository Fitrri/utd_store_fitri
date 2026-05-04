import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../presentation/pages/splash_page.dart';
import '../presentation/pages/home_page.dart'; // 1. Tambah import ini

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(), // 2. Ganti Scaffold lama dengan HomePage
    ),
  ],
);