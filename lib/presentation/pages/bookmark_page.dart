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

  // Fungsi untuk mengambil data dari Isar Database
  Future<void> _loadBookmarks() async {
    final products = await isar.products.where().findAll();
    setState(() {
      bookmarkedProducts = products;
    });
  }

  // Fungsi untuk menghapus bookmark
  Future<void> _deleteBookmark(int id) async {
    await isar.writeTxn(() async {
      await isar.products.delete(id);
    });
    _loadBookmarks(); // Refresh list setelah hapus
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil dihapus dari favorit")),
      );
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: themeBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: bookmarkedProducts.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarkedProducts.length,
              itemBuilder: (context, index) {
                final product = bookmarkedProducts[index];
                return _buildBookmarkCard(product);
              },
            ),
    );
  }

  // Tampilan jika bookmark kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            "Belum ada produk favorit",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Widget Card untuk item bookmark
  Widget _buildBookmarkCard(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 60,
            height: 60,
            color: Colors.white,
            child: Image.network(product.image, fit: BoxFit.contain),
          ),
        ),
        title: Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "\$${product.price}",
              style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Menampilkan Timestamp (Syarat Anti-AI)
            Row(
              children: [
                const Icon(Icons.access_time, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "Disimpan: ${product.savedAt ?? '-'}",
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _deleteBookmark(product.id),
        ),
      ),
    );
  }
}