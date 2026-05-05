import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
          actions: [
            IconButton(
              icon: const Icon(Icons.currency_exchange),
              onPressed: () => context.push('/crypto'),
            ),
            IconButton(
              icon: const Icon(Icons.bookmarks),
              onPressed: () => context.push('/bookmarks'),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (state is ProductSuccess) {
                    return ListView.builder(
                      itemCount: state.products.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      itemBuilder: (context, index) {
                        final product = state.products[index];

                        // LOGIKA PECAH TEKS
                        bool hasPromo = product.title.contains("[Promo Ongkir]");
                        String cleanTitle = product.title.replaceAll("[Promo Ongkir]", "").trim();

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: InkWell(
                            onTap: () => context.push('/detail', extra: product),
                            borderRadius: BorderRadius.circular(15),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
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
                                              style: const TextStyle(
                                                color: Colors.green, 
                                                fontWeight: FontWeight.w900, 
                                                fontSize: 16
                                              ),
                                            ),
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
                                                    Text(
                                                      "Promo Ongkir", 
                                                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                                                    ),
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