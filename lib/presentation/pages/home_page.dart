import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // Tambahkan ini
import '../../core/injection.dart';
import '../cubit/product_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductCubit>()..getProducts(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("UTD Store - Fitri"),
          backgroundColor: Colors.blueAccent,
          elevation: 0,
        ),
        body: Column(
          children: [
            // PONDASI CRYPTO HUB (Tetap Ada)
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.currency_bitcoin, color: Colors.orange),
                      SizedBox(width: 8),
                      Text("BTC/USD (Live):", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text("\$ --,---", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            
            // KATALOG PRODUK
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) return const Center(child: CircularProgressIndicator());
                  if (state is ProductSuccess) {
                    return ListView.builder(
                      itemCount: state.products.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        final product = state.products[index];

                        // LOGIKA PECAH TEKS (Syarat NIM Genap 0 tetap terpenuhi di data)
                        bool hasPromo = product.title.contains("[Promo Ongkir]");
                        String cleanTitle = product.title.replaceAll("[Promo Ongkir]", "").trim();

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: InkWell( // Pakai InkWell supaya ada efek klik
                            onTap: () => context.push('/detail', extra: product),
                            borderRadius: BorderRadius.circular(15),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  // Gambar dengan Frame
                                  Container(
                                    width: 80,
                                    height: 80,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.network(product.image, fit: BoxFit.contain),
                                  ),
                                  const SizedBox(width: 15),
                                  // Info Produk
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cleanTitle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "\$${product.price}",
                                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w900, fontSize: 16),
                                            ),
                                            // BADGE PROMO (Terlihat Modern)
                                            if (hasPromo)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade700,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.local_shipping, size: 12, color: Colors.white),
                                                    SizedBox(width: 4),
                                                    Text("Promo Ongkir", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text("Gagal memuat data"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}