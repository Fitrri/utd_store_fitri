import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/injection.dart';
import '../cubit/product_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeBlue = Colors.blueAccent;

    return BlocProvider(
      create: (context) => sl<ProductCubit>()..getProducts(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: themeBlue,
          elevation: 2,
          title: const Text(
            "UTD Store - Fitri",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bolt_rounded, color: Colors.orange, size: 28),
              onPressed: () => context.push('/crypto'),
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_rounded, color: Colors.yellowAccent, size: 28),
              onPressed: () => context.push('/bookmarks'),
            ),
          ],
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator(color: themeBlue));
            }
            if (state is ProductSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(product.image, width: 80, height: 80, fit: BoxFit.contain),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "\$${product.price}",
                                style: const TextStyle(color: themeBlue, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 14),
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