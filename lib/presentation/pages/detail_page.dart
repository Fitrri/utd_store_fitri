import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import '../../domain/product_model.dart';
import '../../core/injection.dart';

class DetailPage extends StatelessWidget {
  final Product product;
  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    const Color themeBlue = Colors.blueAccent;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeBlue,
        title: const Text(
          "Detail Produk",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk dengan Hero Animation
            Hero(
              tag: product.id,
              child: Container(
                width: double.infinity,
                height: 350,
                color: Colors.white,
                padding: const EdgeInsets.all(30),
                child: Image.network(product.image, fit: BoxFit.contain),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label Kategori
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: themeBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(
                        color: themeBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Judul Produk
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Harga
                  Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(thickness: 1),
                  ),
                  
                  // Deskripsi
                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 100), // Spasi agar tidak tertutup FAB
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Tombol Tambah ke Favorit (Tetap Ada)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final isar = sl<Isar>();
          
          // Set timestamp saat disimpan (Syarat Anti-AI)
          product.savedAt = DateFormat('HH:mm').format(DateTime.now());

          await isar.writeTxn(() async {
            await isar.products.put(product);
          });

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Berhasil disimpan ke Favorit pada ${product.savedAt}"),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.favorite, color: Colors.white),
        label: const Text(
          "Tambah Favorit",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}