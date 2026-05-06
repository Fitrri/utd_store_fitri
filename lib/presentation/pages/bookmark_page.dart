import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../domain/product_model.dart';
import '../../core/injection.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Product> bookmarkedProducts = [];
  final isar = sl<Isar>();

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  // Fungsi mengambil data dari Isar
  Future<void> _loadBookmarks() async {
    final products = await isar.products.where().findAll();
    setState(() {
      bookmarkedProducts = products;
    });
  }

  // Fungsi Hapus yang sudah diperbaiki (Anti-Gagal)
  Future<void> _deleteBookmark(int productId) async {
    try {
      // Cari produk di Isar yang ID-nya cocok dengan ID Produk dari API
      final productToDelete = await isar.products
          .filter()
          .idEqualTo(productId)
          .findFirst();

      if (productToDelete != null) {
        await isar.writeTxn(() async {
          // Hapus menggunakan id internal Isar
          await isar.products.delete(productToDelete.isarId);
        });

        // Refresh daftar setelah hapus
        await _loadBookmarks();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Berhasil dihapus dari favorit"),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error saat menghapus bookmark: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color themeBlue = Colors.blueAccent;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Produk Favorit",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: themeBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: bookmarkedProducts.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: bookmarkedProducts.length,
              itemBuilder: (context, index) {
                final product = bookmarkedProducts[index];
                return _buildBookmarkCard(product);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "Belum ada produk favorit",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ],
      ),
    );
  }

  // Widget Card diperkecil agar seragam dengan HomePage
  Widget _buildBookmarkCard(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Gambar Kecil (Ukuran 65)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 65,
              height: 65,
              color: Colors.white,
              child: Image.network(product.image, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 12),
          // Info Produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${product.price}",
                  style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                // Timestamp (Bukti Anti-AI)
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 10, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      "Disimpan: ${product.savedAt ?? '-'}",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tombol Hapus
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
            onPressed: () => _deleteBookmark(product.id),
          ),
        ],
      ),
    );
  }
}