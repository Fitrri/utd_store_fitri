import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/injection.dart';
import '../../core/services.dart'; 
import '../cubit/product_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeBlue = Colors.blueAccent;
    final batteryService = BatteryService(); 

    return BlocProvider(
      create: (context) => sl<ProductCubit>()..getProducts(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50, // Latar belakang abu tipis agar card lebih kontras
        appBar: AppBar(
          backgroundColor: themeBlue,
          elevation: 2,
          centerTitle: false,
          title: const Text(
            "UTD Store - Fitri",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            // TOMBOL CEK BATERAI - Sekarang Warna Hijau (Sesuai Request)
            IconButton(
              icon: const Icon(Icons.battery_charging_full, color: Colors.greenAccent),
              onPressed: () async {
                final level = await batteryService.getBatteryLevel();
                if (level != null) {
                  batteryService.showNativeToast("Baterai Fitri saat ini: $level%");
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.bolt_rounded, color: Colors.orange, size: 24),
              onPressed: () => context.push('/crypto'),
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_rounded, color: Colors.yellowAccent, size: 24),
              onPressed: () => context.push('/bookmarks'),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator(color: themeBlue));
            }
            if (state is ProductSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10), // Jarak antar card diperkecil
                    padding: const EdgeInsets.all(10), // Padding dalam diperkecil
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan vertikal
                      children: [
                        // Ukuran Gambar diperkecil (Sesuai Request)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 65, // Dari 80 ke 65
                            height: 65,
                            color: Colors.white,
                            child: Image.network(product.image, fit: BoxFit.contain),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                maxLines: 2, // Batasi agar tidak terlalu panjang ke bawah
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "\$${product.price}",
                                style: const TextStyle(
                                  color: themeBlue, 
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 14
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                          onPressed: () => context.push('/detail', extra: product),
                        )
                      ],
                    ),
                  );
                },
              );
            }
            return const Center(child: Text("Gagal memuat data"));
          },
        ),
      ),
    );
  }
}