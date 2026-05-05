import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../presentation/pages/splash_page.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/detail_page.dart'; // Import halaman detail
import '../presentation/pages/crypto_page.dart';   // TAMBAHKAN INI
import '../presentation/pages/bookmark_page.dart'; // TAMBAHKAN INI
import '../domain/product_model.dart';          // Import model Product

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        // Mengambil data product yang dikirim lewat 'extra'
        final product = state.extra as Product;
        return DetailPage(product: product);
      },
    ),
    GoRoute(
  path: '/crypto',
  builder: (context, state) => const CryptoPage(),
),
GoRoute(
  path: '/bookmarks',
  builder: (context, state) => const BookmarkPage(),
),
  ],
);