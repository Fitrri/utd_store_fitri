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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Produk"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk dengan Hero Animation agar smooth
            Hero(
              tag: product.id,
              child: Container(
                width: double.infinity,
                height: 300,
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Image.network(product.image, fit: BoxFit.contain),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "\$${product.price}",
                    style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 30),
                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),

                  // TOMBOL ISOLATE (Poin 4 PDF)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Nanti kita isi logika Isolate di Commit #9
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Menghitung Pajak via Isolate..."))
                        );
                      },
                      icon: const Icon(Icons.calculate),
                      label: const Text("Kalkulasi Pajak (Heavy Task)"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // TOMBOL BOOKMARK/FAVORITE (Poin 3 PDF)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final isar = sl<Isar>();
          
          // Syarat Anti-AI: Tambahkan Timestamp (Jam:Menit)
          product.savedAt = DateFormat('HH:mm').format(DateTime.now());

          await isar.writeTxn(() async {
            await isar.products.put(product);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Disimpan ke Bookmark pada ${product.savedAt}"),
              backgroundColor: Colors.green,
            ),
          );
        },
        label: const Text("Tambah Favorit"),
        icon: const Icon(Icons.favorite, color: Colors.white),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}